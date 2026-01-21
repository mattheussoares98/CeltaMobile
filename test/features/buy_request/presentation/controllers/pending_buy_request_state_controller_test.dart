import 'dart:async';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/providers.dart';
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
      expect(result, PendingBuyRequestEntity.empty());
    });
  });

  group('PendingBuyRequestStateController updatePending', () {
    test(
      'should emit [loading, data] and call repository.update on success',
      () async {
        // ARRANGE
        when(() => mockRepository.load()).thenAnswer(
          (_) async => PendingBuyRequestEntity.empty(),
        ); // Initial state
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
            .updatePending(
              selectedBuyer: entity.selectedBuyer,
              selectedRequestType: entity.selectedRequestType,
              selectedSupplier: entity.selectedSupplier,
              selectedEnterprises: entity.selectedEnterprises,
              products: entity.products,
              lastSavedRequestNumber: entity.lastSavedRequestNumber,
            );

        // ASSERT
        expect(states, [isA<AsyncLoading>(), AsyncData(entity)]);
        verify(() => mockRepository.update(entity)).called(1);
      },
    );

    test('should emit [loading, error] if repository.update fails', () async {
      // ARRANGE
      final exception = Exception('Failed to save');
      when(
        () => mockRepository.load(),
      ).thenAnswer((_) async => PendingBuyRequestEntity.empty());
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
          .updatePending();

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
            .updatePending(selectedSupplier: newSupplier);

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
            .updatePending(); // Same entity

        // ASSERT
        expect(spyEnterprisesController.buildCount, 0);
      },
    );

    test('should annull data when pass null params', () async {
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
          .updatePending(
            selectedBuyer: entity.selectedBuyer,
            selectedRequestType: entity.selectedRequestType,
            selectedSupplier: entity.selectedSupplier,
            selectedEnterprises: entity.selectedEnterprises,
            products: entity.products,
            lastSavedRequestNumber: entity.lastSavedRequestNumber,
            annulProducts: true,
            annulSelectedEnterprises: true,
            annulSelectedSupplier: true,
          );

      final result = await container.read(
        pendingBuyRequestStateControllerProvider.future,
      );
      expect(result.products, null);
      expect(result.selectedEnterprises, null);
      expect(result.selectedSupplier, null);
    });

    test('should clean all data correctly', () async {
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
          .clearState();

      final result = await container.read(
        pendingBuyRequestStateControllerProvider.future,
      );
      expect(result, PendingBuyRequestEntity.empty());

      verify(
        () => mockRepository.update(PendingBuyRequestEntity.empty()),
      ).called(1);
    });
  });
}
