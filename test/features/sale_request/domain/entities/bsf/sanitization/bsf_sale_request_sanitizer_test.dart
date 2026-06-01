// test/features/sale_request/domain/entities/bsf/sanitization/bsf_sale_request_sanitizer_test.dart

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../mocks/mocks.dart';

void main() {
  group('BSFSaleRequestSanitizer Unit Tests', () {
    test(
      'Should add resetPrices action and update product prices according to the new request type when unitValueType changes',
      () {
        // Arrange:
        // Set up the product's price cost with defined retail and wholesale prices.
        final priceCost = EntityFactory.makeBSFPriceCostEntity().copyWith(
          salePracticedInSaleRetail: 10.0,
          salePracticedInWholeSale: 8.0,
          mininumQuantityForWholeSale: 5.0,
        );

        final productItem = EntityFactory.makeBSFProductItemEntity().copyWith(
          value: 10.0,
          quantity: 2.0,
          priceCost: priceCost,
        );

        final initialRequestType = EntityFactory.makeBSFRequestTypeEntity()
            .copyWith(unitValueType: PracticedPriceType.retail);

        final currentRequest = EntityFactory.makeBSFSaleRequestEntity()
            .copyWith(requestType: initialRequestType, products: [productItem]);

        // Define the new request type with a different unit value type (e.g. salePracticedWholeSale)
        final newRequestType = EntityFactory.makeBSFRequestTypeEntity()
            .copyWith(unitValueType: PracticedPriceType.whole);

        // Act:
        final (
          updatedRequest,
          actions,
        ) = BSFSaleRequestSanitizer.sanitizeRequestTypeChange(
          currentRequest,
          newRequestType,
        );

        // Assert:
        // 1. Check if the resetPrices action was added
        expect(actions, contains(BSFSaleRequestSanitizationAction.resetPrices));

        // 2. Check if the new request type was applied
        expect(updatedRequest.requestType, newRequestType);

        // 3. Confirm that the price changed correctly to the wholesale price (8.0)
        expect(updatedRequest.products?.first.value, 8.0);
      },
    );

    test(
      'Should not add resetPrices action or modify product prices when unitValueType does not change',
      () {
        // Arrange:
        final priceCost = EntityFactory.makeBSFPriceCostEntity().copyWith(
          salePracticedInSaleRetail: 10.0,
          salePracticedInWholeSale: 8.0,
          mininumQuantityForWholeSale: 5.0,
        );

        final productItem = EntityFactory.makeBSFProductItemEntity().copyWith(
          value: 10.0,
          quantity: 2.0,
          priceCost: priceCost,
        );

        final initialRequestType = EntityFactory.makeBSFRequestTypeEntity()
            .copyWith(unitValueType: PracticedPriceType.retail);

        final currentRequest = EntityFactory.makeBSFSaleRequestEntity()
            .copyWith(requestType: initialRequestType, products: [productItem]);

        // Act:
        final (
          updatedRequest,
          actions,
        ) = BSFSaleRequestSanitizer.sanitizeRequestTypeChange(
          currentRequest,
          initialRequestType, // No change in unit value type
        );

        // Assert:
        expect(
          actions,
          isNot(contains(BSFSaleRequestSanitizationAction.resetPrices)),
        );
        expect(updatedRequest.products?.first.value, 10.0);
      },
    );
  });
}
