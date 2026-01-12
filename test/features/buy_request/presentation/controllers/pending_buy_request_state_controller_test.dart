import 'dart:async';

import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/buy_request/domain/entities/entities.dart';
import 'package:celta_intelligence/features/buy_request/domain/repository/repository.dart';
import 'package:celta_intelligence/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/buy_request/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// 1. Create a Mock for the repository dependency
class MockLocalPendingBuyRequestRepository extends Mock
    implements ILocalPendingBuyRequestRepository {}

class SpyEnterprisesStateController extends EnterprisesStateController {
  int buildCount = 0;

  @override
  FutureOr<List<EnterpriseEntity>> build() async {
    buildCount++;
    return [];
  }
}

void main() {
  late MockLocalPendingBuyRequestRepository mockRepository;
  late SpyEnterprisesStateController spyEnterprisesController;
  late PendingBuyRequestEntity entity;
  late PendingBuyRequestEntity emptyEntity;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makePendingBuyRequestEntity());
    registerFallbackValue(
      AsyncValue.data([EntityFactory.makeEnterpriseEntity()]),
    );
  });
  setUp(() {
    mockRepository = MockLocalPendingBuyRequestRepository();
    spyEnterprisesController = SpyEnterprisesStateController();
    entity = EntityFactory.makePendingBuyRequestEntity();
    emptyEntity = PendingBuyRequestEntity.empty();
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        localPendingBuyRequestRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        enterprisesStateControllerProvider.overrideWith(
          () => spyEnterprisesController,
        ),
        userSessionProvider.overrideWith(
          () => FakeUserSession(
            UserSessionModel.fromEntity(EntityFactory.makeUserSessionEntity()),
          ),
        ),
      ],
    );
  }

  group('PendingBuyRequestStateController build', () {
    test('should load and return existing data from repository', () async {
      // ARRANGE
      when(() => mockRepository.load()).thenAnswer((_) async => entity);

      final container = makeProviderContainer();
      addTearDown(container.dispose);

      // ACT: Wait for the build method to complete
      final result = await container.read(
        pendingBuyRequestStateControllerProvider.future,
      );

      // ASSERT
      expect(result, entity);
      verify(() => mockRepository.load()).called(1);
    });

    test('should return an empty entity if repository returns null', () async {
      // ARRANGE
      when(() => mockRepository.load()).thenAnswer((_) async => null);

      final container = makeProviderContainer();

      // ACT
      final result = await container.read(
        pendingBuyRequestStateControllerProvider.future,
      );

      // ASSERT
      expect(result, emptyEntity);
    });
  });

  group('PendingBuyRequestStateController updatePending', () {
    test(
      'should emit [loading, data] and call repository.update on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(),
        ).thenAnswer((_) async => emptyEntity); // Initial state
        when(() => mockRepository.update(any())).thenAnswer((_) async {
          await Future.delayed(Duration.zero); // Simulate async delay
        });

        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(
          pendingBuyRequestStateControllerProvider.future,
        ); // Wait for initial build

        final states = <AsyncValue<PendingBuyRequestEntity>>[];
        container.listen(
          pendingBuyRequestStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(pendingBuyRequestStateControllerProvider.notifier)
            .updatePending(entity);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), AsyncData(entity)]);
        verify(() => mockRepository.update(entity)).called(1);
      },
    );

    test('should emit [loading, error] if repository.update fails', () async {
      // ARRANGE
      final exception = Exception('Failed to save');
      when(() => mockRepository.load()).thenAnswer((_) async => emptyEntity);
      when(() => mockRepository.update(any())).thenThrow(exception);

      final container = makeProviderContainer();
      addTearDown(container.dispose);
      await container.read(pendingBuyRequestStateControllerProvider.future);

      final states = <AsyncValue<PendingBuyRequestEntity>>[];
      container.listen(
        pendingBuyRequestStateControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(pendingBuyRequestStateControllerProvider.notifier)
          .updatePending(entity);

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });

  group('PendingBuyRequestStateController Invalidation Logic', () {
    test(
      'should re-build enterprisesStateControllerProvider when supplier changes',
      () async {
        // ARRANGE
        final newSupplier = EntityFactory.makeSupplierEntity();
        final updatedEntity = entity.copyWith(selectedSupplier: newSupplier);

        when(() => mockRepository.load()).thenAnswer((_) async => entity);
        when(() => mockRepository.update(any())).thenAnswer((_) async {});

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // 1. Initial read to trigger the first build
        await container.read(pendingBuyRequestStateControllerProvider.future);
        expect(spyEnterprisesController.buildCount, 0);

        // ACT
        await container
            .read(pendingBuyRequestStateControllerProvider.notifier)
            .updatePending(updatedEntity);

        // ASSERT
        // If ref.invalidate was called, the buildCount must be 2
        expect(spyEnterprisesController.buildCount, 1);
      },
    );

    test(
      'should NOT re-build enterprisesStateControllerProvider when data remains the same',
      () async {
        // ARRANGE
        when(() => mockRepository.load()).thenAnswer((_) async => entity);
        when(() => mockRepository.update(any())).thenAnswer((_) async {});

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        await container.read(pendingBuyRequestStateControllerProvider.future);
        expect(spyEnterprisesController.buildCount, 0);

        // ACT
        await container
            .read(pendingBuyRequestStateControllerProvider.notifier)
            .updatePending(entity); // Same entity

        // ASSERT
        expect(spyEnterprisesController.buildCount, 0);
      },
    );
  });
}
