import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/adjust_cost/domain/entity/entity.dart';
import 'package:celta_inventario/features/adjust_cost/domain/repository/repository.dart';
import 'package:celta_inventario/features/adjust_cost/presentation/controllers/confirm_adjust_cost_controller.dart';
import 'package:celta_inventario/features/adjust_cost/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Mocks and Fakes ---

class MockEcAdjustCostRepository extends Mock
    implements IEcAdjustCostRepository {}

void main() {
  late MockEcAdjustCostRepository mockRepository;
  late UserSessionModel fakeSession;
  late AdjustCostParametersEntity fakeParams;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeAdjustCostParametersEntity());
  });

  setUp(() {
    mockRepository = MockEcAdjustCostRepository();

    // Generating dynamic data via faker
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );

    fakeParams = EntityFactory.makeAdjustCostParametersEntity();
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecAdjustCostRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('ConfirmAdjustCostController', () {
    test('Initial state should be AsyncData(null)', () async {
      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      await container.read(confirmAdjustCostControllerProvider.future);

      final state = container.read(confirmAdjustCostControllerProvider);

      // build() is async but returns null immediately in our mock setup.
      expect(state, isA<AsyncData>());
    });

    test(
      'confirm should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.adjust(
            workingUrl: any(named: 'workingUrl'),
            user: any(named: 'user'),
            accessKey: any(named: 'accessKey'),
            parameters: any(named: 'parameters'),
          ),
        ).thenAnswer((_) async {});

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          confirmAdjustCostControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(confirmAdjustCostControllerProvider.notifier)
            .confirm(fakeParams);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), const AsyncData<void>(null)]);

        verify(
          () => mockRepository.adjust(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            user: fakeSession.user.name!,
            accessKey: fakeSession.user.AccessKey!,
            parameters: fakeParams,
          ),
        ).called(1);
      },
    );

    test('confirm should emit [loading, error] if repository fails', () async {
      // ARRANGE
      final exception = Exception(faker.lorem.sentence());

      when(
        () => mockRepository.adjust(
          workingUrl: any(named: 'workingUrl'),
          user: any(named: 'user'),
          accessKey: any(named: 'accessKey'),
          parameters: any(named: 'parameters'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT
      await container
          .read(confirmAdjustCostControllerProvider.notifier)
          .confirm(fakeParams);

      // ASSERT
      final state = container.read(confirmAdjustCostControllerProvider);
      expect(state, isA<AsyncError>());
      expect(state.error, exception);
    });

    test('confirm should emit error if session is null', () async {
      // ARRANGE
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      // ACT
      await container
          .read(confirmAdjustCostControllerProvider.notifier)
          .confirm(fakeParams);

      // ASSERT
      final state = container.read(confirmAdjustCostControllerProvider);

      // Because you use 'validatedUser!', this results in a Null Check error
      expect(state, isA<AsyncError>());

      verifyNever(
        () => mockRepository.adjust(
          workingUrl: any(named: 'workingUrl'),
          user: any(named: 'user'),
          accessKey: any(named: 'accessKey'),
          parameters: any(named: 'parameters'),
        ),
      );
    });
  });
}
