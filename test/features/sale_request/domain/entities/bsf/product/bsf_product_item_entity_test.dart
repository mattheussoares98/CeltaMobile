// test/features/sale_request/domain/entities/bsf/product/bsf_product_item_entity_test.dart

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../mocks/mocks.dart';

void main() {
  group('BSFProductItemEntity Price Cost Unit Tests', () {
    test(
      'Should return the correct price for each RequestUnitValueType when quantity is below wholesale threshold',
      () {
        // Arrange:
        // Create a map to store expected distinct prices for each unit value type.
        final Map<PracticedPriceType, double> expectedPrices = {};

        // Loop through all unit value types and generate a unique mock price using faker.
        var baseMockPrice = 10.0;
        for (final type in PracticedPriceType.values) {
          // Add a random increment so they are guaranteed to be unique
          baseMockPrice += faker.randomGenerator.decimal() * 10 + 1.0;
          expectedPrices[type] = double.parse(baseMockPrice.toStringAsFixed(2));
        }

        // Set up priceCost using these generated prices.
        // For properties where there are options (e.g. salePracticedInSaleRetail vs saleRetailPricePractice),
        // we populate the primary ones (the ones checked first).
        final priceCost = EntityFactory.makeBSFPriceCostEntity().copyWith(
          salePracticedInSaleRetail: expectedPrices[PracticedPriceType.retail],
          salePracticedInWholeSale: expectedPrices[PracticedPriceType.whole],
          operationCost: expectedPrices[PracticedPriceType.operationalCost],
          replacementCost: expectedPrices[PracticedPriceType.replacementCost],
          mediumReplacementCost:
              expectedPrices[PracticedPriceType.replacementCostMidle],
          liquidCost: expectedPrices[PracticedPriceType.liquidCost],
          mediumLiquidCost: expectedPrices[PracticedPriceType.liquidCostMidle],
          replacementCostReal: expectedPrices[PracticedPriceType.realCost],
          liquidCostReal: expectedPrices[PracticedPriceType.realLiquidCost],
          replacementCostFiscal: expectedPrices[PracticedPriceType.fiscalCost],
          liquidCostFiscal: expectedPrices[PracticedPriceType.fiscalLiquidCost],
          salePracticedInECommerce:
              expectedPrices[PracticedPriceType.ecommerce],
          mininumQuantityForWholeSale: 5.0,
        );

        // Keep quantity = 1.0 (which is less than the wholesale threshold of 5.0)
        final productItem = EntityFactory.makeBSFProductItemEntity().copyWith(
          quantity: 1.0,
          priceCost: priceCost,
          value:
              expectedPrices[PracticedPriceType
                  .manual], // Set manual value for matching check
        );

        // Act & Assert in a loop:
        for (final type in PracticedPriceType.values) {
          final returnedPrice = productItem
              .getPriceAccordingToUnitValueTypeAndQuantities(type);

          // Under normal quantity (< 5.0):
          // definedBySystem should resolve to the retail price (salePracticedRetail).
          double expectedPrice;
          if (type == PracticedPriceType.definedBySystem) {
            expectedPrice = expectedPrices[PracticedPriceType.retail]!;
          } else {
            expectedPrice = expectedPrices[type]!;
          }

          expect(
            returnedPrice,
            expectedPrice,
            reason: 'For $type, expected $expectedPrice but got $returnedPrice',
          );
        }
      },
    );

    test(
      'Should return wholesale price for definedBySystem when quantity meets or exceeds wholesale threshold',
      () {
        // Arrange:
        final retailPrice = faker.randomGenerator.decimal() * 10 + 10.0;
        final wholePrice = faker.randomGenerator.decimal() * 10 + 5.0;

        final priceCost = EntityFactory.makeBSFPriceCostEntity().copyWith(
          salePracticedInSaleRetail: retailPrice,
          salePracticedInWholeSale: wholePrice,
          mininumQuantityForWholeSale: 5.0,
        );

        // Quantity >= wholesale threshold (5.0)
        final productItem = EntityFactory.makeBSFProductItemEntity().copyWith(
          quantity: 5.0,
          priceCost: priceCost,
        );

        // Act:
        final returnedPrice = productItem
            .getPriceAccordingToUnitValueTypeAndQuantities(
              PracticedPriceType.definedBySystem,
            );

        // Assert:
        expect(returnedPrice, wholePrice);
      },
    );
    test(
      'Should return retail price when there is whole price but minimum quantity is null or zero',
      () {
        // Arrange:
        final retailPrice = faker.randomGenerator.decimal() * 10 + 10.0;
        final wholePrice = faker.randomGenerator.decimal() * 10 + 5.0;

        final priceCost = EntityFactory.makeBSFPriceCostEntity().copyWith(
          salePracticedInSaleRetail: retailPrice,
          salePracticedInWholeSale: wholePrice,
          mininumQuantityForWholeSale: 0,
          anullMininumQuantityForWholeSale: faker.randomGenerator.boolean(),
        );

        // Quantity >= wholesale threshold (5.0)
        final productItem = EntityFactory.makeBSFProductItemEntity().copyWith(
          quantity: 5.0,
          priceCost: priceCost,
        );

        // Act:
        final returnedPrice = productItem
            .getPriceAccordingToUnitValueTypeAndQuantities(
              PracticedPriceType.definedBySystem,
            );

        // Assert:
        expect(returnedPrice, retailPrice);
      },
    );

    test('Should return 0.0 when priceCost is null', () {
      // Arrange:
      final productItem = BSFProductItemEntity.empty();

      // Act & Assert in a loop:
      for (final type in PracticedPriceType.values) {
        final returnedPrice = productItem
            .getPriceAccordingToUnitValueTypeAndQuantities(type);
        expect(returnedPrice, 0.0);
      }
    });

    group('getPracticedPriceType', () {
      test('returns manual if requestType is null', () {
        final productItem = EntityFactory.makeBSFProductItemEntity();
        expect(
          productItem.getPracticedPriceType(null),
          PracticedPriceType.manual,
        );
      });

      test('returns manual if value is null', () {
        final requestType = EntityFactory.makeBSFRequestTypeEntity();
        final productItem = EntityFactory.makeBSFProductItemEntity().copyWith(
          value: null,
        );
        expect(
          productItem.getPracticedPriceType(requestType),
          PracticedPriceType.manual,
        );
      });

      test(
        'returns requestType.unitValueType if value is equal to expectedPrice',
        () {
          final requestType = EntityFactory.makeBSFRequestTypeEntity().copyWith(
            unitValueType: PracticedPriceType.retail,
          );
          final priceCost = EntityFactory.makeBSFPriceCostEntity().copyWith(
            salePracticedInSaleRetail: 10.0,
          );
          final productItem = EntityFactory.makeBSFProductItemEntity().copyWith(
            quantity: 1.0,
            value: 10.0,
            priceCost: priceCost,
          );

          expect(
            productItem.getPracticedPriceType(requestType),
            PracticedPriceType.retail,
          );
        },
      );

      test('returns manual if value is different from expectedPrice', () {
        final requestType = EntityFactory.makeBSFRequestTypeEntity().copyWith(
          unitValueType: PracticedPriceType.retail,
        );
        final priceCost = EntityFactory.makeBSFPriceCostEntity().copyWith(
          salePracticedInSaleRetail: 10.0,
        );
        final productItem = EntityFactory.makeBSFProductItemEntity().copyWith(
          quantity: 1.0,
          value: 9.50, // User forced manual price override
          priceCost: priceCost,
        );

        expect(
          productItem.getPracticedPriceType(requestType),
          PracticedPriceType.manual,
        );
      });
    });
  });
}
