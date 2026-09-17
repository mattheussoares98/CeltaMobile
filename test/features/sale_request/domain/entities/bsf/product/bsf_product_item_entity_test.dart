import 'package:flutter_test/flutter_test.dart';

import '../../../../../../mocks/entity_factory.dart';

void main() {
  group('BSFProductItemEntity prices', () {
    test('should prioritize practice prices when they are positive', () {
      final item = EntityFactory.makeBSFProductItemEntity().copyWith(
        priceCost: EntityFactory.makeBSFPriceCostEntity().copyWith(
          wholeSalePricePractice: 10,
          salePracticedInWholeSale: 20,
          saleRetailPricePractice: 30,
          salePracticedInSaleRetail: 40,
        ),
      );

      expect(item.wholePrice, 10);
      expect(item.retailPrice, 30);
    });

    test('should use practiced prices when practice prices are zero', () {
      final item = EntityFactory.makeBSFProductItemEntity().copyWith(
        priceCost: EntityFactory.makeBSFPriceCostEntity().copyWith(
          wholeSalePricePractice: 0,
          salePracticedInWholeSale: 20,
          saleRetailPricePractice: 0,
          salePracticedInSaleRetail: 40,
        ),
      );

      expect(item.wholePrice, 20);
      expect(item.retailPrice, 40);
    });

    test('should report no price when item and retail prices are zero', () {
      final item = EntityFactory.makeBSFProductItemEntity().copyWith(
        value: 0,
        priceCost: EntityFactory.makeBSFPriceCostEntity().copyWith(
          saleRetailPricePractice: 0,
          salePracticedInSaleRetail: 0,
        ),
      );

      expect(item.hasNoPrice, isTrue);
    });

    test('should report a price when item value is positive', () {
      final item = EntityFactory.makeBSFProductItemEntity().copyWith(
        value: 10,
        priceCost: EntityFactory.makeBSFPriceCostEntity().copyWith(
          saleRetailPricePractice: 0,
          salePracticedInSaleRetail: 0,
        ),
      );

      expect(item.hasNoPrice, isFalse);
    });
  });
}
