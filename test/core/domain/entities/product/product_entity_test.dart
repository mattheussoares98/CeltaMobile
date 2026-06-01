import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/entity_factory.dart';

// Helper to make a product entity with direct fields cleared, except specific ones.
ProductEntity _makeCleanProductDirect({
  required Map<PracticedPriceType, double> prices,
  required double value,
}) {
  return EntityFactory.makeProductEntity(
    Value: value,
    clearPriceCost: true,
  ).copyWith(
    RetailPracticedPrice: prices[PracticedPriceType.retail] ?? 0.0,
    WholePracticedPrice: prices[PracticedPriceType.whole] ?? 0.0,
    OperationalCost: prices[PracticedPriceType.operationalCost] ?? 0.0,
    ReplacementCost: prices[PracticedPriceType.replacementCost] ?? 0.0,
    ReplacementCostMidle: prices[PracticedPriceType.replacementCostMidle] ?? 0.0,
    LiquidCost: prices[PracticedPriceType.liquidCost] ?? 0.0,
    LiquidCostMidle: prices[PracticedPriceType.liquidCostMidle] ?? 0.0,
    RealCost: prices[PracticedPriceType.realCost] ?? 0.0,
    RealLiquidCost: prices[PracticedPriceType.realLiquidCost] ?? 0.0,
    FiscalCost: prices[PracticedPriceType.fiscalCost] ?? 0.0,
    FiscalLiquidCost: prices[PracticedPriceType.fiscalLiquidCost] ?? 0.0,
    ECommercePracticedPrice: prices[PracticedPriceType.ecommerce] ?? 0.0,
    MinimumWholeQuantity: 5.0, // Threshold for wholesale
  );
}

// Helper to make a product entity with direct fields set to 0, fallback to PriceCost Entity.
ProductEntity _makeCleanProductPriceCost({
  required Map<PracticedPriceType, double> prices,
  required double value,
}) {
  final baseProduct = EntityFactory.makeProductEntity(
    Value: value,
    clearPriceCost: true,
  ).copyWith(
    RetailPracticedPrice: 0.0,
    WholePracticedPrice: 0.0,
    OperationalCost: 0.0,
    ReplacementCost: 0.0,
    ReplacementCostMidle: 0.0,
    LiquidCost: 0.0,
    LiquidCostMidle: 0.0,
    RealCost: 0.0,
    RealLiquidCost: 0.0,
    FiscalCost: 0.0,
    FiscalLiquidCost: 0.0,
    ECommercePracticedPrice: 0.0,
    MinimumWholeQuantity: 0.0,
  );

  final priceCost = PriceCostEntity(
    RetailPracticedPrice: prices[PracticedPriceType.retail],
    WholePracticedPrice: prices[PracticedPriceType.whole],
    OperationalCost: prices[PracticedPriceType.operationalCost],
    ReplacementCost: prices[PracticedPriceType.replacementCost],
    ReplacementCostMidle: prices[PracticedPriceType.replacementCostMidle],
    LiquidCost: prices[PracticedPriceType.liquidCost],
    LiquidCostMidle: prices[PracticedPriceType.liquidCostMidle],
    RealCost: prices[PracticedPriceType.realCost],
    RealLiquidCost: prices[PracticedPriceType.realLiquidCost],
    FiscalCost: prices[PracticedPriceType.fiscalCost],
    FiscalLiquidCost: prices[PracticedPriceType.fiscalLiquidCost],
    ECommercePracticedPrice: prices[PracticedPriceType.ecommerce],
    MinimumWholeQuantity: 5.0,
    RetailSalePrice: 0.0,
    RetailOfferPrice: 0.0,
    RetailSuggestionPrice: 0.0,
    RetailMinimumPrice: 0.0,
    WholeSalePrice: 0.0,
    WholeOfferPrice: 0.0,
    WholeSuggestionPrice: 0.0,
    WholeMinimumPrice: 0.0,
    ECommerceSalePrice: 0.0,
    ECommerceOfferPrice: 0.0,
    ECommerceSuggestionPrice: 0.0,
    ECommerceMinimumPrice: 0.0,
    RetailMargin: 0.0,
    RetailOfferMargin: 0.0,
    RetailMinimumMargin: 0.0,
    WholeMargin: 0.0,
    WholeOfferMargin: 0.0,
    WholeMinimumMargin: 0.0,
    ECommerceMargin: 0.0,
    ECommerceOfferMargin: 0.0,
    ECommerceMinimumMargin: 0.0,
  );

  return baseProduct.copyWith(PriceCost: priceCost);
}

void main() {
  final prices = {
    PracticedPriceType.retail: 10.1,
    PracticedPriceType.whole: 10.2,
    PracticedPriceType.operationalCost: 10.3,
    PracticedPriceType.replacementCost: 10.4,
    PracticedPriceType.replacementCostMidle: 10.5,
    PracticedPriceType.liquidCost: 10.6,
    PracticedPriceType.liquidCostMidle: 10.7,
    PracticedPriceType.realCost: 10.8,
    PracticedPriceType.realLiquidCost: 10.9,
    PracticedPriceType.fiscalCost: 11.0,
    PracticedPriceType.fiscalLiquidCost: 11.1,
    PracticedPriceType.ecommerce: 11.2,
  };

  group('ProductEntity - getPracticedPriceType when manualPrice is not null', () {
    test(
      'always returns PracticedPriceType.manual regardless of value matching system price',
      () {
        final product = EntityFactory.makeProductEntity(
          MinimumWholeQuantity: 10,
          RetailPracticedPrice: 5.50,
          Value: 0.0,
          clearPriceCost: true,
        ).copyWith(WholePracticedPrice: 4.50);

        // Even if the manual price is identical to the retail price (5.50), it must return manual
        final type1 = product.getPracticedPriceType(
          quantity: 5,
          manualPrice: 5.50,
        );
        expect(type1, PracticedPriceType.manual);

        // Even if the manual price is identical to the wholesale price (4.50), it must return manual
        final type2 = product.getPracticedPriceType(
          quantity: 12,
          manualPrice: 4.50,
        );
        expect(type2, PracticedPriceType.manual);
      },
    );
  });

  group(
    'ProductEntity - getPracticedPriceType when manualPrice is null (all possible types matching)',
    () {
      test(
        'loops and returns correct type for Direct Fields when manualPrice is null',
        () {
          prices.forEach((type, price) {
            // For wholesale, the quantity needs to meet the MinimumWholeQuantity (5.0, so we pass 10.0)
            final quantity = type == PracticedPriceType.whole ? 10.0 : 1.0;

            final product = _makeCleanProductDirect(
              prices: prices,
              value: price,
            );

            final resolvedType = product.getPracticedPriceType(
              quantity: quantity,
              manualPrice: null,
            );

            expect(
              resolvedType,
              type,
              reason: 'Failed direct fields match for $type',
            );
          });
        },
      );

      test(
        'loops and returns correct type for PriceCost nested fields when manualPrice is null',
        () {
          prices.forEach((type, price) {
            // For wholesale, the quantity needs to meet the MinimumWholeQuantity (5.0, so we pass 10.0)
            final quantity = type == PracticedPriceType.whole ? 10.0 : 1.0;

            final product = _makeCleanProductPriceCost(
              prices: prices,
              value: price,
            );

            final resolvedType = product.getPracticedPriceType(
              quantity: quantity,
              manualPrice: null,
            );

            expect(
              resolvedType,
              type,
              reason: 'Failed PriceCost fields match for $type',
            );
          });
        },
      );
    },
  );

  group('ProductEntity - getPracticedPrice calculations', () {
    test('returns manualPrice when type is manual', () {
      final product = EntityFactory.makeProductEntity();
      final price = product.getPracticedPrice(quantity: 1, manualPrice: 15.0);
      expect(price, 15.0);
    });

    test(
      'returns retail price when system calculated price is retail and manualPrice is null',
      () {
        final product = EntityFactory.makeProductEntity(
          MinimumWholeQuantity: 10,
          RetailPracticedPrice: 10.0,
          Value: 0.0,
          clearPriceCost: true,
        ).copyWith(WholePracticedPrice: 8.0);

        final price = product.getPracticedPrice(quantity: 5, manualPrice: null);
        expect(price, 10.0);
      },
    );

    test(
      'returns wholesale price when system calculated price is wholesale and manualPrice is null',
      () {
        final product = EntityFactory.makeProductEntity(
          MinimumWholeQuantity: 10,
          RetailPracticedPrice: 10.0,
          Value: 0.0,
          clearPriceCost: true,
        ).copyWith(WholePracticedPrice: 8.0);

        final price = product.getPracticedPrice(
          quantity: 12,
          manualPrice: null,
        );
        expect(price, 8.0);
      },
    );
  });
}
