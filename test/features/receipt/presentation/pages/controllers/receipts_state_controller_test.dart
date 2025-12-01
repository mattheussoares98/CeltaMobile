import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
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

void main() {
  late MockSoapLoadReceiptsRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<ReceiptEntity> fakeReceipts;
  late int enterpriseCode;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
    registerFallbackValue('any_string');
  });

  setUp(() {
    mockRepository = MockSoapLoadReceiptsRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    enterpriseCode = faker.randomGenerator.integer(100);
    fakeReceipts = [EntityFactory.makeReceiptEntity()];
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapLoadReceiptsRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
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
}
