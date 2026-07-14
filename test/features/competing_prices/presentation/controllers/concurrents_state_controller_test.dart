import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/domain/repository/repository.dart';
import 'package:celta_inventario/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/competing_prices/providers/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes and Mocks for Dependencies ---

class MockSoapConcurrentsRepository extends Mock
    implements ISoapConcurrentsRepository {}

void main() {
  late MockSoapConcurrentsRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<ConcurrentEntity> fakeConcurrents;
  late String fakeName;
  late String fakeObservation;
  late AddressEntity fakeAddress;

  setUpAll(() {
    // Register fallback for mocktail
    registerFallbackValue('any_string');
  });

  setUp(() {
    mockRepository = MockSoapConcurrentsRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeConcurrents = [EntityFactory.makeConcurrentEntity()];
    fakeName = faker.company.name();
    fakeObservation = faker.lorem.sentence();
    fakeAddress = EntityFactory.makeAddressEntity();
    when(
      () => mockRepository.insertUpdate(
        crossIdentity: any(named: 'crossIdentity'),
        workingUrl: any(named: 'workingUrl'),
        concurrentCode: any(named: 'concurrentCode'),
        concurrentName: any(named: 'concurrentName'),
        observation: any(named: 'observation'),
        address: any(named: 'address'),
      ),
    ).thenAnswer((_) async {});
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        soapConcurrentsRepositoryProvider.overrideWithValue(mockRepository),
        // Override the keepAlive provider
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  Future<void> setupInitialLoad(
    ProviderContainer container, {
    required List<ConcurrentEntity> data,
  }) async {
    when(
      () => mockRepository.load(
        crossIdentity: any(named: 'crossIdentity'),
        workingUrl: any(named: 'workingUrl'),
        searchValue: any(named: 'searchValue'),
      ),
    ).thenAnswer((_) async => data);
    await container.read(concurrentsStateControllerProvider.future);
  }

  group('ConcurrentsStateController', () {
    test(
      'should return list of concurrents and call repository with searchValue: null on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            crossIdentity: any(named: 'crossIdentity'),
            workingUrl: any(named: 'workingUrl'),
            searchValue: any(named: 'searchValue'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
          return fakeConcurrents;
        });

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          concurrentsStateControllerProvider.future,
        );

        // ASSERT
        expect(result, fakeConcurrents);
        verify(
          () => mockRepository.load(
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            workingUrl: fakeSession.enterprise!.workingUrl!,
          ),
        ).called(1);
      },
    );

    test(
      'should throw AppException when validatedUserSession is invalid',
      () async {
        // ARRANGE
        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // ACT & ASSERT
        await expectLater(
          container.read(concurrentsStateControllerProvider.future),
          throwsA(isA<AppException>()),
        );

        // Verify the repository was never called
        verifyNever(
          () => mockRepository.load(
            crossIdentity: any(named: 'crossIdentity'),
            workingUrl: any(named: 'workingUrl'),
            searchValue: any(named: 'searchValue'),
          ),
        );
      },
    );

    test('should throw if repository fails', () async {
      // ARRANGE
      final exception = Exception('Network Error');
      when(
        () => mockRepository.load(
          crossIdentity: any(named: 'crossIdentity'),
          workingUrl: any(named: 'workingUrl'),
          searchValue: any(named: 'searchValue'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(concurrentsStateControllerProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('ConcurrentsStateController insertUpdate', () {
    test(
      'should update local state when editing existing concurrent (Code != null)',
      () async {
        // ARRANGE
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        await setupInitialLoad(container, data: fakeConcurrents);

        // ACT
        await container
            .read(concurrentsStateControllerProvider.notifier)
            .insertUpdate(
              concurrentCode:
                  fakeConcurrents.first.ConcurrentCode, // Update existing code
              name: fakeName,
              observation: fakeObservation,
              address: fakeAddress,
            );

        // ASSERT
        // 1. Verify repository was called
        verify(
          () => mockRepository.insertUpdate(
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            workingUrl: fakeSession.enterprise!.workingUrl!,
            concurrentCode: fakeConcurrents.first.ConcurrentCode,
            concurrentName: fakeName,
            observation: fakeObservation,
            address: fakeAddress,
          ),
        ).called(1);

        // 2. Verify local list update was performed

        final updatedState = container
            .read(concurrentsStateControllerProvider)
            .value;
        expect(updatedState!.first.Name, fakeName);
        expect(updatedState.first.Observation, fakeObservation);
        expect(updatedState.first.Address, fakeAddress);
      },
    );

    test(
      'should invalidate self when inserting new concurrent (Code == null)',
      () async {
        // ARRANGE
        when(
          () => mockRepository.insertUpdate(
            concurrentCode: null,
            concurrentName: any(named: 'concurrentName'),
            observation: any(named: 'observation'),
            address: any(named: 'address'),
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
          ),
        ).thenAnswer((_) async {});

        when(
          () => mockRepository.load(
            crossIdentity: any(named: 'crossIdentity'),
            workingUrl: any(named: 'workingUrl'),
            searchValue: any(named: 'searchValue'),
          ),
        ).thenAnswer((_) async => fakeConcurrents);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        await container.read(
          concurrentsStateControllerProvider.future,
        ); // Initial build

        // ACT
        await container
            .read(concurrentsStateControllerProvider.notifier)
            .insertUpdate(
              concurrentCode: null, // Insert new
              name: fakeName,
              observation: fakeObservation,
              address: fakeAddress,
            );

        expect(
          container.read(concurrentsStateControllerProvider).value,
          isEmpty, //because invalidate
        );
        // ASSERT
        // 1. Verify repository was called with null code
        verify(
          () => mockRepository.insertUpdate(
            concurrentCode: null,
            concurrentName: fakeName,
            observation: fakeObservation,
            address: fakeAddress,
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
          ),
        ).called(1);

        // 2. Verify invalidateSelf was called
      },
    );
  });
}
