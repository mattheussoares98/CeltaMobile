import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/models/models.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes and Mocks ---

void main() {
  late EnterpriseEntity fakeEnterprise;
  late ProductEntity fakeProduct;

  setUpAll(() {
    registerFallbackValue(const AsyncLoading<AdjustPriceUIModel>());
  });

  setUp(() {
    fakeEnterprise = EntityFactory.makeEnterpriseEntity(
      enterpriseParticipateEnterpriseGroup: false,
    );
    fakeProduct = EntityFactory.makeProductEntity(
      isFatherOfGrate: false,
      isChildOfGrate: false,
      inClass: false,
      alterationPriceForAllPackings: false,
      markUpdateClassInAdjustSalePriceIndividual: false,
    );
  });

  ProviderContainer makeProviderContainer({
    EnterpriseEntity? enterprise,
    ProductEntity? product,
  }) {
    return ProviderContainer(
      overrides: [
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(enterprise),
        ),
        selectedProductStateControllerProvider(
          enterprise!.Code!,
          fakeProduct.PLU!,
        ).overrideWith(() => FakeSelectedProductStateController(product)),
      ],
    );
  }

  group('UIStateController', () {
    group('build', () {
      test(
        'should initialize with grid replication if product is father of grate',
        () async {
          // Arrange
          final product = fakeProduct.copyWith(IsFatherOfGrate: true);
          final container = makeProviderContainer(
            enterprise: fakeEnterprise,
            product: product,
          );
          addTearDown(container.dispose);

          // Act
          final state = await container.read(
            uIStateControllerProvider(product.PLU!).future,
          );

          // Assert
          expect(state.availableReplications, contains(ReplicationTypes.grid));
        },
      );

      test(
        'should initialize with operationalGrouping if enterprise is in group',
        () async {
          // Arrange
          final enterprise = fakeEnterprise.copyWith(
            EnterpriseParticipateEnterpriseGroup: true,
          );
          final container = makeProviderContainer(enterprise: enterprise);
          addTearDown(container.dispose);

          // Act
          final state = await container.read(
            uIStateControllerProvider(fakeProduct.PLU!).future,
          );

          // Assert
          expect(
            state.availableReplications,
            contains(ReplicationTypes.operationalGrouping),
          );
          // It should also be selected by default according to logic
          expect(
            state.selectedReplications,
            contains(ReplicationTypes.operationalGrouping),
          );
        },
      );

      test(
        'should select packings by default if product flag is true',
        () async {
          // Arrange
          final product = fakeProduct.copyWith(
            AlterationPriceForAllPackings: true,
          );
          final container = makeProviderContainer(
            enterprise: fakeEnterprise,
            product: product,
          );
          addTearDown(container.dispose);

          // Act
          final state = await container.read(
            uIStateControllerProvider(product.PLU!).future,
          );

          // Assert
          expect(
            state.selectedReplications,
            contains(ReplicationTypes.packings),
          );
        },
      );
    });

    group('updateValues', () {
      test('should toggle replication (add if absent)', () async {
        // Arrange
        final container = makeProviderContainer(enterprise: fakeEnterprise);
        addTearDown(container.dispose);

        // Wait for build
        await container.read(
          uIStateControllerProvider(fakeProduct.PLU!).future,
        );
        final notifier = container.read(
          uIStateControllerProvider(fakeProduct.PLU!).notifier,
        );

        // Act
        await notifier.updateValues(selectedReplication: ReplicationTypes.grid);

        // Assert
        final finalState = container
            .read(uIStateControllerProvider(fakeProduct.PLU!))
            .value;
        expect(
          finalState!.selectedReplications,
          contains(ReplicationTypes.grid),
        );
      });

      test('should toggle replication (remove if present)', () async {
        // Arrange
        final product = fakeProduct.copyWith(
          AlterationPriceForAllPackings: true,
        );
        final container = makeProviderContainer(
          enterprise: fakeEnterprise,
          product: product,
        );
        addTearDown(container.dispose);

        await container.read(uIStateControllerProvider(product.PLU!).future);
        final notifier = container.read(
          uIStateControllerProvider(product.PLU!).notifier,
        );

        // Act
        await notifier.updateValues(
          selectedReplication: ReplicationTypes.packings,
        );

        // Assert
        final finalState = container
            .read(uIStateControllerProvider(product.PLU!))
            .value;
        expect(
          finalState!.selectedReplications,
          isNot(contains(ReplicationTypes.packings)),
        );
      });

      test('should update dates and types correctly', () async {
        // Arrange
        final container = makeProviderContainer(enterprise: fakeEnterprise);
        addTearDown(container.dispose);

        await container.read(
          uIStateControllerProvider(fakeProduct.PLU!).future,
        );
        final notifier = container.read(
          uIStateControllerProvider(fakeProduct.PLU!).notifier,
        );

        final startDate = DateTime.now();
        final endDate = DateTime.now().add(const Duration(days: 7));
        const saleType = SaleType.whole;
        const priceType = PriceType.offer;

        // Act
        await notifier.updateValues(
          selectedStartDate: startDate,
          selectedEndDate: endDate,
          selectedSaleType: saleType,
          selectedPriceType: priceType,
        );

        // Assert
        final finalState = container
            .read(uIStateControllerProvider(fakeProduct.PLU!))
            .value!;
        expect(finalState.selectedStartDate, startDate);
        expect(finalState.selectedEndDate, endDate);
        expect(finalState.selectedSaleType, saleType);
        expect(finalState.selectedPriceType, priceType);
      });

      test('should change end date correctly', () async {
        // Arrange
        final container = makeProviderContainer(enterprise: fakeEnterprise);
        addTearDown(container.dispose);

        await container.read(
          uIStateControllerProvider(fakeProduct.PLU!).future,
        );
        final state1 = container
            .read(uIStateControllerProvider(fakeProduct.PLU!))
            .value!;
        expect(state1.selectedStartDate, isNull);

        final notifier = container.read(
          uIStateControllerProvider(fakeProduct.PLU!).notifier,
        );

        final startDate = DateTime.now();
        final endDate = DateTime.now().add(const Duration(days: 7));

        // Act
        await notifier.updateValues(
          selectedStartDate: startDate,
          selectedEndDate: endDate,
        );
        // Assert
        final state2 = container
            .read(uIStateControllerProvider(fakeProduct.PLU!))
            .value!;
        expect(state2.selectedStartDate, isNotNull);
        expect(state2.selectedEndDate, isNotNull);

        // Act
        await notifier.updateValues(
          selectedStartDate: startDate,
          selectedEndDate: null,
          isChangingEndDate: true,
        );
        // Assert
        final state3 = container
            .read(uIStateControllerProvider(fakeProduct.PLU!))
            .value!;
        expect(state3.selectedEndDate, isNull);
      });
    });
    group('updateValues loading state', () {
      test('should emit loading then data', () async {
        // Arrange
        final container = makeProviderContainer(enterprise: fakeEnterprise);
        addTearDown(container.dispose);
        await container.read(
          uIStateControllerProvider(fakeProduct.PLU!).future,
        );

        final states = <AsyncValue<AdjustPriceUIModel>>[];
        container.listen(
          uIStateControllerProvider(fakeProduct.PLU!),
          (p, n) => states.add(n),
        );

        // Act
        await container
            .read(uIStateControllerProvider(fakeProduct.PLU!).notifier)
            .updateValues(isSelectedClass: true);

        // Assert
        expect(states.first, isA<AsyncLoading>());
        expect(states.last, isA<AsyncData>());
        expect(states.last.value!.isSelectedClass, isTrue);
      });
    });
  });
}
