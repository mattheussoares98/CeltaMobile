import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  final testProduct = EntityFactory.makeBSFSaleRequestEntity().products!.first;

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('InsertProductUIController', () {
    test('build should initialize state from product', () async {
      // ARRANGE
      final container = makeProviderContainer();

      // ACT
      final result = container.read(
        insertProductUIControllerProvider(testProduct),
      );

      // ASSERT
      expect(result.quantity, testProduct.quantity ?? 1);
      expect(result.price, testProduct.value ?? 0);
      expect(result.deliveryTaxValue, testProduct.deliveryTax?.value ?? 0);
      expect(
        result.deliveryTaxType,
        testProduct.deliveryTax?.type ?? PercentageOrValue.reais,
      );
      expect(result.incrementValue, testProduct.increment?.value ?? 0);
      expect(
        result.incrementType,
        testProduct.increment?.type ?? PercentageOrValue.reais,
      );
      expect(result.discounts, testProduct.discounts ?? []);
    });

    group('updateQuantity', () {
      const retailPrice = 10.0;
      const wholePrice = 8.0;
      const minWhole = 5.0;

      final productWithWholesale = testProduct.copyWith(
        value: retailPrice,
        quantity: 1,
        priceCost: testProduct.priceCost?.copyWith(
          salePracticedInSaleRetail: retailPrice,
          salePracticedInWholeSale: wholePrice,
          mininumQuantityForWholeSale: minWhole,
        ),
      );

      test(
        'should update quantity and keep retail price when below threshold',
        () async {
          // ARRANGE
          final container = makeProviderContainer();
          container.read(
            insertProductUIControllerProvider(productWithWholesale),
          );

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(productWithWholesale),
            (_, next) => states.add(next),
          );

          // ACT
          const newQuantity = 4.0; // below 5.0
          container
              .read(
                insertProductUIControllerProvider(
                  productWithWholesale,
                ).notifier,
              )
              .updateQuantity(newQuantity);

          // ASSERT
          expect(states.length, 1);
          expect(states.first.quantity, newQuantity);
          expect(states.first.price, retailPrice);
        },
      );

      test('should apply wholesale price when quantity >= threshold', () async {
        // ARRANGE
        final container = makeProviderContainer();
        container.read(insertProductUIControllerProvider(productWithWholesale));

        final states = <InsertProductUIState>[];
        container.listen(
          insertProductUIControllerProvider(productWithWholesale),
          (_, next) => states.add(next),
        );

        // ACT
        const newQuantity = 5.0; // matches threshold
        container
            .read(
              insertProductUIControllerProvider(productWithWholesale).notifier,
            )
            .updateQuantity(newQuantity);

        // ASSERT
        expect(states.length, 1);
        expect(states.first.quantity, newQuantity);
        expect(states.first.price, wholePrice);
      });

      test(
        'should revert to retail price when quantity falls below threshold',
        () async {
          // ARRANGE
          final container = makeProviderContainer();
          final notifier = container.read(
            insertProductUIControllerProvider(productWithWholesale).notifier,
          );

          // Start at wholesale
          notifier.updateQuantity(10.0);

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(productWithWholesale),
            (_, next) => states.add(next),
          );

          // ACT
          const newQuantity = 2.0; // below 5.0
          notifier.updateQuantity(newQuantity);

          // ASSERT
          expect(states.first.price, retailPrice);
          expect(states.first.quantity, newQuantity);
        },
      );

      test(
        'should apply wholeSalePricePractice if salePracticedInWholeSale is null',
        () async {
          // ARRANGE
          final productWithPracticeWholesale = testProduct.copyWith(
            quantity: 1,
            priceCost: testProduct.priceCost?.copyWith(
              salePracticedInSaleRetail: retailPrice,
              anullSalePracticedInWholeSale: true,
              wholeSalePricePractice: wholePrice,
              mininumQuantityForWholeSale: minWhole,
            ),
          );
          final container = makeProviderContainer();
          container.read(
            insertProductUIControllerProvider(productWithPracticeWholesale),
          );

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(productWithPracticeWholesale),
            (_, next) => states.add(next),
          );

          // ACT
          const newQuantity = 5.0; // matches threshold
          container
              .read(
                insertProductUIControllerProvider(
                  productWithPracticeWholesale,
                ).notifier,
              )
              .updateQuantity(newQuantity);

          // ASSERT
          expect(states.first.price, wholePrice);
        },
      );

      test(
        'should apply saleRetailPricePractice if salePracticedInSaleRetail is null',
        () async {
          // ARRANGE
          final productWithPracticeRetail = testProduct.copyWith(
            quantity: 1,
            priceCost: testProduct.priceCost?.copyWith(
              anullSalePracticedInSaleRetail: true,
              saleRetailPricePractice: retailPrice,
              salePracticedInWholeSale: wholePrice,
              mininumQuantityForWholeSale: minWhole,
            ),
          );
          final container = makeProviderContainer();
          container.read(
            insertProductUIControllerProvider(productWithPracticeRetail),
          );

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(productWithPracticeRetail),
            (_, next) => states.add(next),
          );

          // ACT
          const newQuantity = 1.0; // below threshold
          container
              .read(
                insertProductUIControllerProvider(
                  productWithPracticeRetail,
                ).notifier,
              )
              .updateQuantity(newQuantity);

          // ASSERT
          expect(states.first.price, retailPrice);
        },
      );
    });

    group('updatePrice', () {
      test('should update only the price preserving other values', () async {
        // ARRANGE
        final container = makeProviderContainer();
        container.read(insertProductUIControllerProvider(testProduct));

        final states = <InsertProductUIState>[];
        container.listen(
          insertProductUIControllerProvider(testProduct),
          (_, next) => states.add(next),
        );

        // ACT
        final newPrice = faker.randomGenerator.decimal();
        container
            .read(insertProductUIControllerProvider(testProduct).notifier)
            .updatePrice(newPrice);

        // ASSERT
        expect(states.length, 1);
        expect(states.first.price, newPrice);
        expect(states.first.quantity, testProduct.quantity ?? 1);
      });
    });

    group('updateDeliveryTaxValue', () {
      test(
        'should update only the delivery tax value preserving other values',
        () async {
          // ARRANGE
          final container = makeProviderContainer();
          container.read(insertProductUIControllerProvider(testProduct));

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(testProduct),
            (_, next) => states.add(next),
          );

          // ACT
          final newValue = faker.randomGenerator.decimal();
          container
              .read(insertProductUIControllerProvider(testProduct).notifier)
              .updateDeliveryTaxValue(newValue);

          // ASSERT
          expect(states.length, 1);
          expect(states.first.deliveryTaxValue, newValue);
          expect(states.first.quantity, testProduct.quantity ?? 1);
        },
      );
    });

    group('updateDeliveryTaxType', () {
      test(
        'should update only the delivery tax type preserving other values',
        () async {
          // ARRANGE
          final container = makeProviderContainer();
          final initialState = container.read(
            insertProductUIControllerProvider(testProduct),
          );

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(testProduct),
            (_, next) => states.add(next),
          );

          // ACT - pick the opposite type to guarantee a change
          final newType =
              initialState.deliveryTaxType == PercentageOrValue.percentage
              ? PercentageOrValue.reais
              : PercentageOrValue.percentage;
          container
              .read(insertProductUIControllerProvider(testProduct).notifier)
              .updateDeliveryTaxType(newType);

          // ASSERT
          expect(states.length, 1);
          expect(states.first.deliveryTaxType, newType);
          expect(states.first.quantity, testProduct.quantity ?? 1);
        },
      );
    });

    group('updateIncrementValue', () {
      test(
        'should update only the increment value preserving other values',
        () async {
          // ARRANGE
          final container = makeProviderContainer();
          container.read(insertProductUIControllerProvider(testProduct));

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(testProduct),
            (_, next) => states.add(next),
          );

          // ACT
          final newValue = faker.randomGenerator.decimal();
          container
              .read(insertProductUIControllerProvider(testProduct).notifier)
              .updateIncrementValue(newValue);

          // ASSERT
          expect(states.length, 1);
          expect(states.first.incrementValue, newValue);
          expect(states.first.quantity, testProduct.quantity ?? 1);
        },
      );
    });

    group('updateIncrementType', () {
      test(
        'should update only the increment type preserving other values',
        () async {
          // ARRANGE
          final container = makeProviderContainer();
          final initialState = container.read(
            insertProductUIControllerProvider(testProduct),
          );

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(testProduct),
            (_, next) => states.add(next),
          );

          // ACT - pick the opposite type to guarantee a change
          final newType =
              initialState.incrementType == PercentageOrValue.percentage
              ? PercentageOrValue.reais
              : PercentageOrValue.percentage;
          container
              .read(insertProductUIControllerProvider(testProduct).notifier)
              .updateIncrementType(newType);

          // ASSERT
          expect(states.length, 1);
          expect(states.first.incrementType, newType);
          expect(states.first.quantity, testProduct.quantity ?? 1);
        },
      );
    });

    group('addDiscount', () {
      test(
        'should add a discount to the list when type is percentage',
        () async {
          // ARRANGE
          final container = makeProviderContainer();
          container.read(insertProductUIControllerProvider(testProduct));

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(testProduct),
            (_, next) => states.add(next),
          );

          final firstDiscount = EntityFactory.makeBSFDiscountEntity(
            discount: BSFValueTypeEntity(
              type: PercentageOrValue.percentage,
              value: faker.randomGenerator.decimal(),
            ),
          );
          final secondDiscount = EntityFactory.makeBSFDiscountEntity(
            discount: BSFValueTypeEntity(
              type: PercentageOrValue.percentage,
              value: faker.randomGenerator.decimal(),
            ),
          );

          // ACT
          container
              .read(insertProductUIControllerProvider(testProduct).notifier)
              .addDiscount(firstDiscount);
          container
              .read(insertProductUIControllerProvider(testProduct).notifier)
              .addDiscount(secondDiscount);

          // ASSERT
          expect(states.length, 2);
          expect(states.last.discounts, contains(firstDiscount));
          expect(states.last.discounts, contains(secondDiscount));
        },
      );

      test('should replace all discounts when type is reais', () async {
        // ARRANGE
        final container = makeProviderContainer();
        container.read(insertProductUIControllerProvider(testProduct));

        final states = <InsertProductUIState>[];
        container.listen(
          insertProductUIControllerProvider(testProduct),
          (_, next) => states.add(next),
        );

        final newDiscount = EntityFactory.makeBSFDiscountEntity(
          discount: const BSFValueTypeEntity(
            type: PercentageOrValue.reais,
            value: 10,
          ),
        );

        // ACT
        container
            .read(insertProductUIControllerProvider(testProduct).notifier)
            .addDiscount(newDiscount);

        // ASSERT
        expect(states.length, 1);
        expect(states.first.discounts, [newDiscount]);
        expect(states.first.discounts.length, 1);
      });
    });

    group('removeDiscount', () {
      test('should remove a discount from the list at given index', () async {
        // ARRANGE
        final container = makeProviderContainer();
        container.read(insertProductUIControllerProvider(testProduct));

        final states = <InsertProductUIState>[];
        container.listen(
          insertProductUIControllerProvider(testProduct),
          (_, next) => states.add(next),
        );

        // ACT
        container
            .read(insertProductUIControllerProvider(testProduct).notifier)
            .removeDiscount(0);

        // ASSERT
        expect(states.length, 1);
        expect(
          states.first.discounts.length,
          testProduct.discounts!.length - 1,
        );
      });
    });

    group('updateDiscountType', () {
      test(
        'should update discountType and first discount type if exists',
        () async {
          // ARRANGE
          final container = makeProviderContainer();
          container.read(insertProductUIControllerProvider(testProduct));

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(testProduct),
            (_, next) => states.add(next),
          );

          const newType = PercentageOrValue.percentage;

          // ACT
          container
              .read(insertProductUIControllerProvider(testProduct).notifier)
              .updateDiscountType(newType);

          // ASSERT
          expect(states.length, 1);
          expect(states.first.discountType, newType);
          if (testProduct.discounts!.isNotEmpty) {
            expect(states.first.discounts.first.discount?.type, newType);
          }
        },
      );
    });
  });
}
