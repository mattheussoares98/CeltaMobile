// test/features/sale_request/domain/entities/bsf/product/bsf_product_item_entity_test.dart

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';

import '../../../../../../mocks/mocks.dart';

void main() {
  group('BSFProductItemEntity Price Cost Unit Tests', () {
    test(
      'Should return the correct price for each RequestUnitValueType when quantity is below wholesale threshold',
      () {
        // Arrange:
        // Create a map to store expected distinct prices for each unit value type.
        final Map<RequestUnitValueType, double> expectedPrices = {};

        // Loop through all unit value types and generate a unique mock price using faker.
        var baseMockPrice = 10.0;
        for (final type in RequestUnitValueType.values) {
          // Add a random increment so they are guaranteed to be unique
          baseMockPrice += faker.randomGenerator.decimal() * 10 + 1.0;
          expectedPrices[type] = double.parse(baseMockPrice.toStringAsFixed(2));
        }

        // Set up priceCost using these generated prices.
        // For properties where there are options (e.g. salePracticedInSaleRetail vs saleRetailPricePractice),
        // we populate the primary ones (the ones checked first).
        final priceCost = EntityFactory.makeBSFPriceCostEntity().copyWith(
          salePracticedInSaleRetail: expectedPrices[RequestUnitValueType.salePracticedRetail],
          salePracticedInWholeSale: expectedPrices[RequestUnitValueType.salePracticedWholeSale],
          operationCost: expectedPrices[RequestUnitValueType.operationalCost],
          replacementCost: expectedPrices[RequestUnitValueType.replacementCost],
          mediumReplacementCost: expectedPrices[RequestUnitValueType.replacementCostMidle],
          liquidCost: expectedPrices[RequestUnitValueType.liquidCost],
          mediumLiquidCost: expectedPrices[RequestUnitValueType.liquidCostMidle],
          replacementCostReal: expectedPrices[RequestUnitValueType.realCost],
          liquidCostReal: expectedPrices[RequestUnitValueType.realLiquidCost],
          replacementCostFiscal: expectedPrices[RequestUnitValueType.fiscalCost],
          liquidCostFiscal: expectedPrices[RequestUnitValueType.fiscalLiquidCost],
          salePracticedInECommerce: expectedPrices[RequestUnitValueType.salePracticedECommerce],
          mininumQuantityForWholeSale: 5.0,
        );

        // Keep quantity = 1.0 (which is less than the wholesale threshold of 5.0)
        final productItem = EntityFactory.makeBSFProductItemEntity().copyWith(
          quantity: 1.0,
          priceCost: priceCost,
        );

        // Act & Assert in a loop:
        for (final type in RequestUnitValueType.values) {
          final returnedPrice = productItem.getPriceAccordingToUnitValueTypeAndQuantities(type);

          // Under normal quantity (< 5.0):
          // definedBySystem should resolve to the retail price (salePracticedRetail).
          double expectedPrice;
          if (type == RequestUnitValueType.definedBySystem) {
            expectedPrice = expectedPrices[RequestUnitValueType.salePracticedRetail]!;
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
        final returnedPrice = productItem.getPriceAccordingToUnitValueTypeAndQuantities(
          RequestUnitValueType.definedBySystem,
        );

        // Assert:
        expect(returnedPrice, wholePrice);
      },
    );

    test(
      'Should upgrade retail price to wholesale price for salePracticedRetail when quantity meets or exceeds wholesale threshold',
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
          quantity: 6.0,
          priceCost: priceCost,
        );

        // Act:
        final returnedPrice = productItem.getPriceAccordingToUnitValueTypeAndQuantities(
          RequestUnitValueType.salePracticedRetail,
        );

        // Assert:
        expect(returnedPrice, wholePrice);
      },
    );

    test(
      'Should return 0.0 when priceCost is null',
      () {
        // Arrange:
        final productItem = BSFProductItemEntity.empty();

        // Act & Assert in a loop:
        for (final type in RequestUnitValueType.values) {
          final returnedPrice = productItem.getPriceAccordingToUnitValueTypeAndQuantities(type);
          expect(returnedPrice, 0.0);
        }
      },
    );
  });
}