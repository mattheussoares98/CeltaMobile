import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/receipt/domain/entity/entity.dart';
import 'package:celta_intelligence/features/receipt/domain/repository/repository.dart';
import 'package:celta_intelligence/features/receipt/presentation/pages/controllers/controllers.dart';
import 'package:celta_intelligence/features/receipt/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks/mocks.dart';

// --- Fakes and Mocks for Dependencies ---

class MockSoapLoadReceiptsRepository extends Mock
    implements ISoapLoadReceiptsRepository {}

class MockSoapUpdateObservationsDatasource extends Mock
    implements ISoapUpdateObservationsDatasource {}

void main() {
  late MockSoapLoadReceiptsRepository mockRepository;
  late MockSoapUpdateObservationsDatasource mockUpdateDatasource;
  late UserSessionModel fakeSession;
  late List<ReceiptEntity> fakeReceipts;
  late int enterpriseCode;
  late int targetDocCode;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
    registerFallbackValue('any_string');
  });

  setUp(() {
    mockRepository = MockSoapLoadReceiptsRepository();
    mockUpdateDatasource = MockSoapUpdateObservationsDatasource();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    enterpriseCode = faker.randomGenerator.integer(100);
    targetDocCode = faker.randomGenerator.integer(200, min: 100);
    fakeReceipts = [
      EntityFactory.makeReceiptEntity(
        CodigoInterno_ProcRecebDoc: targetDocCode,
      ),
      EntityFactory.makeReceiptEntity(),
      EntityFactory.makeReceiptEntity(),
    ];
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapLoadReceiptsRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        soapUpdateObservationsDatasourceProvider.overrideWithValue(
          mockUpdateDatasource,
        ),
      ],
    );
  }

  group('ReceiptsStateController', () {
    test(
      'should return list of receipts and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.loadReceipts(
            crossIdentity: any(named: 'crossIdentity'),
            baseUrl: any(named: 'baseUrl'),
            enterpriseCode: any(named: 'enterpriseCode'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
          return fakeReceipts;
        });

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          receiptsStateControllerProvider(enterpriseCode).future,
        );

        // ASSERT
        expect(result, fakeReceipts);
        verify(
          () => mockRepository.loadReceipts(
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            baseUrl: fakeSession.enterprise!.baseUrl!,
            enterpriseCode: enterpriseCode,
          ),
        ).called(1);
      },
    );

    test(
      'should throw AppException when validatedUserSession is invalid',
      () async {
        // ARRANGE
        final container = makeProviderContainer(session: null);
        addTearDown(container.dispose);

        // ACT & ASSERT
        await expectLater(
          container.read(
            receiptsStateControllerProvider(enterpriseCode).future,
          ),
          throwsA(isA<AppException>()),
        );

        // Verify the repository was never called
        verifyNever(
          () => mockRepository.loadReceipts(
            crossIdentity: any(named: 'crossIdentity'),
            baseUrl: any(named: 'baseUrl'),
            enterpriseCode: any(named: 'enterpriseCode'),
          ),
        );
      },
    );
  });

  group('ReceiptsStateController updateObservations', () {
    test('should update local list optimistically', () async {
      // ARRANGE
      final newObservations = faker.lorem.sentence();

      // 1. Stub the LOAD method to return the initial list
      when(
        () => mockRepository.loadReceipts(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          enterpriseCode: any(named: 'enterpriseCode'),
        ),
      ).thenAnswer((_) async => fakeReceipts);

      // 2. Stub the UPDATE method to simulate success
      when(
        () => mockUpdateDatasource.update(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          CodigoInterno_ProcRecebDoc: any(named: 'CodigoInterno_ProcRecebDoc'),
          observations: any(named: 'observations'),
        ),
      ).thenAnswer((_) async {});

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // Wait for build to load initial state
      await container.read(
        receiptsStateControllerProvider(enterpriseCode).future,
      );

      final states = <AsyncValue<List<ReceiptEntity>>>[];
      container.listen(
        receiptsStateControllerProvider(enterpriseCode),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(receiptsStateControllerProvider(enterpriseCode).notifier)
          .updateObservationsLocally(newObservations, targetDocCode);

      // ASSERT
      // 1. Check state transitions (Loading -> Data)
      expect(states, [isA<AsyncData>()]);

      // 2. Verify remote datasource was called
      verifyNever(
        () => mockUpdateDatasource.update(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          CodigoInterno_ProcRecebDoc: any(named: 'CodigoInterno_ProcRecebDoc'),
          observations: any(named: 'observations'),
        ),
      );

      // 3. Verify local update (optimistic change)
      final finalState = container
          .read(receiptsStateControllerProvider(enterpriseCode))
          .value!;
      final updatedReceipt = finalState.firstWhere(
        (e) => e.CodigoInterno_ProcRecebDoc == targetDocCode,
      );

      expect(updatedReceipt.Observacoes_ProcRecebDoc, newObservations);
      expect(
        finalState.length,
        fakeReceipts.length,
      ); // Ensure list size is preserved
    });

    test(
      'should return without saving if list is empty or null initially',
      () async {
        // ARRANGE
        when(
          () => mockRepository.loadReceipts(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseCode: any(named: 'enterpriseCode'),
          ),
        ).thenAnswer((_) async => []); // Returns empty list

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // Wait for build
        await container.read(
          receiptsStateControllerProvider(enterpriseCode).future,
        );

        // ACT
        await container
            .read(receiptsStateControllerProvider(enterpriseCode).notifier)
            .updateObservationsLocally('New Obs', targetDocCode);

        // ASSERT
        // 1. Verify remote datasource was never called
        verifyNever(
          () => mockUpdateDatasource.update(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            CodigoInterno_ProcRecebDoc: any(
              named: 'CodigoInterno_ProcRecebDoc',
            ),
            observations: any(named: 'observations'),
          ),
        );

        // 2. State should remain AsyncData([])
        final finalState = container.read(
          receiptsStateControllerProvider(enterpriseCode),
        );
        expect(finalState.value, isEmpty);
      },
    );
  });
}
