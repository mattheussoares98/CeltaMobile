import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/models/models.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(retry: (retryCount, error) => null);
    addTearDown(container.dispose);
    return container;
  }

  final testProduct = EntityFactory.makeBSFSaleRequestEntity().products!.first;

  group('InsertProductUIController', () {
    test('build should initialize state from product', () async {
      // ARRANGE
      final container = makeProviderContainer();

      // ACT
      final result = container.read(
        insertProductUIControllerProvider(product: testProduct),
      );

      // ASSERT
      expect(result.quantity, testProduct.quantity ?? 1);
      expect(result.price, testProduct.value ?? 0);
      expect(result.observations, '');
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
      test('should update only the quantity preserving other values', () async {
        // ARRANGE
        final container = makeProviderContainer();
        container.read(insertProductUIControllerProvider(product: testProduct));

        final states = <InsertProductUIState>[];
        container.listen(
          insertProductUIControllerProvider(product: testProduct),
          (_, next) => states.add(next),
        );

        // ACT
        final newQuantity = faker.randomGenerator.decimal();
        container
            .read(
              insertProductUIControllerProvider(product: testProduct).notifier,
            )
            .updateQuantity(newQuantity);

        // ASSERT
        expect(states.length, 1);
        expect(states.first.quantity, newQuantity);
        expect(states.first.price, testProduct.value ?? 0);
      });
    });

    group('updatePrice', () {
      test('should update only the price preserving other values', () async {
        // ARRANGE
        final container = makeProviderContainer();
        container.read(insertProductUIControllerProvider(product: testProduct));

        final states = <InsertProductUIState>[];
        container.listen(
          insertProductUIControllerProvider(product: testProduct),
          (_, next) => states.add(next),
        );

        // ACT
        final newPrice = faker.randomGenerator.decimal();
        container
            .read(
              insertProductUIControllerProvider(product: testProduct).notifier,
            )
            .updatePrice(newPrice);

        // ASSERT
        expect(states.length, 1);
        expect(states.first.price, newPrice);
        expect(states.first.quantity, testProduct.quantity ?? 1);
      });
    });

    group('updateObservations', () {
      test(
        'should update only the observations preserving other values',
        () async {
          // ARRANGE
          final container = makeProviderContainer();
          container.read(
            insertProductUIControllerProvider(product: testProduct),
          );

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(product: testProduct),
            (_, next) => states.add(next),
          );

          // ACT
          final newObservations = faker.lorem.sentence();
          container
              .read(
                insertProductUIControllerProvider(
                  product: testProduct,
                ).notifier,
              )
              .updateObservations(newObservations);

          // ASSERT
          expect(states.length, 1);
          expect(states.first.observations, newObservations);
          expect(states.first.quantity, testProduct.quantity ?? 1);
        },
      );
    });

    group('updateDeliveryTaxValue', () {
      test(
        'should update only the delivery tax value preserving other values',
        () async {
          // ARRANGE
          final container = makeProviderContainer();
          container.read(
            insertProductUIControllerProvider(product: testProduct),
          );

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(product: testProduct),
            (_, next) => states.add(next),
          );

          // ACT
          final newValue = faker.randomGenerator.decimal();
          container
              .read(
                insertProductUIControllerProvider(
                  product: testProduct,
                ).notifier,
              )
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
            insertProductUIControllerProvider(product: testProduct),
          );

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(product: testProduct),
            (_, next) => states.add(next),
          );

          // ACT - pick the opposite type to guarantee a change
          final newType =
              initialState.deliveryTaxType == PercentageOrValue.percentage
              ? PercentageOrValue.reais
              : PercentageOrValue.percentage;
          container
              .read(
                insertProductUIControllerProvider(
                  product: testProduct,
                ).notifier,
              )
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
          container.read(
            insertProductUIControllerProvider(product: testProduct),
          );

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(product: testProduct),
            (_, next) => states.add(next),
          );

          // ACT
          final newValue = faker.randomGenerator.decimal();
          container
              .read(
                insertProductUIControllerProvider(
                  product: testProduct,
                ).notifier,
              )
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
            insertProductUIControllerProvider(product: testProduct),
          );

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(product: testProduct),
            (_, next) => states.add(next),
          );

          // ACT - pick the opposite type to guarantee a change
          final newType =
              initialState.incrementType == PercentageOrValue.percentage
              ? PercentageOrValue.reais
              : PercentageOrValue.percentage;
          container
              .read(
                insertProductUIControllerProvider(
                  product: testProduct,
                ).notifier,
              )
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
          container.read(
            insertProductUIControllerProvider(product: testProduct),
          );

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(product: testProduct),
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
              .read(
                insertProductUIControllerProvider(
                  product: testProduct,
                ).notifier,
              )
              .addDiscount(firstDiscount);
          container
              .read(
                insertProductUIControllerProvider(
                  product: testProduct,
                ).notifier,
              )
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
        container.read(insertProductUIControllerProvider(product: testProduct));

        final states = <InsertProductUIState>[];
        container.listen(
          insertProductUIControllerProvider(product: testProduct),
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
            .read(
              insertProductUIControllerProvider(product: testProduct).notifier,
            )
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
        container.read(insertProductUIControllerProvider(product: testProduct));

        final states = <InsertProductUIState>[];
        container.listen(
          insertProductUIControllerProvider(product: testProduct),
          (_, next) => states.add(next),
        );

        // ACT
        container
            .read(
              insertProductUIControllerProvider(product: testProduct).notifier,
            )
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
          container.read(
            insertProductUIControllerProvider(product: testProduct),
          );

          final states = <InsertProductUIState>[];
          container.listen(
            insertProductUIControllerProvider(product: testProduct),
            (_, next) => states.add(next),
          );

          const newType = PercentageOrValue.percentage;

          // ACT
          container
              .read(
                insertProductUIControllerProvider(
                  product: testProduct,
                ).notifier,
              )
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

    group('getUpdatedProduct', () {
      test(
        'should return the product with all updated values applied',
        () async {
          // ARRANGE
          final container = makeProviderContainer();
          container.read(
            insertProductUIControllerProvider(product: testProduct),
          );

          const newQuantity = 3.0;
          const newPrice = 50.0;
          const newDeliveryTaxValue = 5.0;
          const newDeliveryTaxType = PercentageOrValue.percentage;
          const newIncrementValue = 2.0;
          const newIncrementType = PercentageOrValue.reais;
          final newDiscount = EntityFactory.makeBSFDiscountEntity();

          final notifier = container.read(
            insertProductUIControllerProvider(product: testProduct).notifier,
          );

          // ACT
          notifier.updateQuantity(newQuantity);
          notifier.updatePrice(newPrice);
          notifier.updateDeliveryTaxValue(newDeliveryTaxValue);
          notifier.updateDeliveryTaxType(newDeliveryTaxType);
          notifier.updateIncrementValue(newIncrementValue);
          notifier.updateIncrementType(newIncrementType);
          notifier.addDiscount(newDiscount);

          final result = notifier.getUpdatedProduct();

          // ASSERT
          expect(result.quantity, newQuantity);
          expect(result.value, newPrice);
          expect(result.deliveryTax?.value, newDeliveryTaxValue);
          expect(result.deliveryTax?.type, newDeliveryTaxType);
          expect(result.increment?.value, newIncrementValue);
          expect(result.increment?.type, newIncrementType);
          expect(result.discounts, contains(newDiscount));
          // Unchanged fields
          expect(result.product, testProduct.product);
          expect(result.fiscalCode, testProduct.fiscalCode);
          expect(result.eanCode, testProduct.eanCode);
        },
      );

      test('should return null deliveryTax when value is 0', () async {
        // ARRANGE
        final container = makeProviderContainer();
        container.read(insertProductUIControllerProvider(product: testProduct));

        final notifier = container.read(
          insertProductUIControllerProvider(product: testProduct).notifier,
        );

        // ACT
        notifier.updateDeliveryTaxValue(0);
        final result = notifier.getUpdatedProduct();

        // ASSERT
        expect(result.deliveryTax, isNull);
      });

      test('should return null increment when value is 0', () async {
        // ARRANGE
        final container = makeProviderContainer();
        container.read(insertProductUIControllerProvider(product: testProduct));

        final notifier = container.read(
          insertProductUIControllerProvider(product: testProduct).notifier,
        );

        // ACT
        notifier.updateIncrementValue(0);
        final result = notifier.getUpdatedProduct();

        // ASSERT
        expect(result.increment, isNull);
      });
    });
  });
}
