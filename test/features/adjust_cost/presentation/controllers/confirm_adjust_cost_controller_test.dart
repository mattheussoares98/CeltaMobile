import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/adjust_cost/domain/entity/entity.dart';
import 'package:celta_inventario/features/adjust_cost/domain/repository/repository.dart';
import 'package:celta_inventario/features/adjust_cost/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_cost/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Mocks and Fakes ---

class MockEcAdjustCostRepository extends Mock
    implements IEcAdjustCostRepository {}

class FakeSelectedProductIndexStateController
    extends SelectedProductIndexStateController {
  FakeSelectedProductIndexStateController();

  // 2. Override the build method to return your fake data instantly
  @override
  int? build(int enterpriseCode) {
    return null;
  }
}

void main() {
  late MockEcAdjustCostRepository mockRepository;
  late UserSessionModel fakeSession;
  late AdjustCostParametersEntity fakeParams;
  late int enterpriseCode;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeAdjustCostParametersEntity());
  });

  setUp(() {
    mockRepository = MockEcAdjustCostRepository();

    enterpriseCode = faker.randomGenerator.integer(1000);

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
        selectedProductIndexStateControllerProvider.overrideWith2(
          (enterpriseCode) => FakeSelectedProductIndexStateController(),
        ),
      ],
    );
  }

  group('ConfirmAdjustCostController', () {
    test('Initial state should be AsyncData(null)', () async {
      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      await container.read(
        confirmAdjustCostControllerProvider(enterpriseCode).future,
      );

      final state = container.read(
        confirmAdjustCostControllerProvider(enterpriseCode),
      );

      // build() is async but returns null immediately in our mock setup.
      expect(state, isA<AsyncData>());
    });

    test('confirm behave correctly on success', () async {
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

      //update the index to test if will reset to null after confirm
      container
          .read(
            selectedProductIndexStateControllerProvider(
              enterpriseCode,
            ).notifier,
          )
          .updateIndex(0);
      expect(
        container.read(
          selectedProductIndexStateControllerProvider(enterpriseCode),
        ),
        0,
      );

      final states = <AsyncValue<void>>[];
      container.listen(
        confirmAdjustCostControllerProvider(enterpriseCode),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(confirmAdjustCostControllerProvider(enterpriseCode).notifier)
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

      //confirm that has reseted the selected product index to null after confirm
      expect(
        container.read(
          selectedProductIndexStateControllerProvider(enterpriseCode),
        ),
        null,
      );
    });

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
          .read(confirmAdjustCostControllerProvider(enterpriseCode).notifier)
          .confirm(fakeParams);

      // ASSERT
      final state = container.read(
        confirmAdjustCostControllerProvider(enterpriseCode),
      );
      expect(state, isA<AsyncError>());
      expect(state.error, exception);
    });

    test('confirm should emit error if session is null', () async {
      // ARRANGE
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      // ACT
      await container
          .read(confirmAdjustCostControllerProvider(enterpriseCode).notifier)
          .confirm(fakeParams);

      // ASSERT
      final state = container.read(
        confirmAdjustCostControllerProvider(enterpriseCode),
      );

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
