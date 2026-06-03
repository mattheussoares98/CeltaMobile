// test/features/sale_request/domain/entities/bsf/bsf_sale_request_entity_test.dart
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../../mocks/entity_factory.dart';

void main() {
  group('BSFSaleRequestEntity needsProcessingComparedTo', () {
    late BSFSaleRequestEntity original;

    setUp(() {
      original = EntityFactory.makeBSFSaleRequestEntity();
    });

    test('should return true when compared to null', () {
      expect(original.needsProcessingComparedTo(null), isTrue);
    });

    test('should return false when compared to itself or an identical copy', () {
      expect(original.needsProcessingComparedTo(original), isFalse);
      
      final copy = original.copyWith();
      expect(original.needsProcessingComparedTo(copy), isFalse);
    });

    test('should return true when customer code is different', () {
      final updatedCustomer = original.customer?.copyWith(
        code: (original.customer?.code ?? 0) + 999,
      );
      final other = original.copyWith(customer: updatedCustomer);
      expect(original.needsProcessingComparedTo(other), isTrue);
    });

    test('should return true when selected covenant code is different', () {
      final updatedCovenant = original.customer?.selectedCovenant?.copyWith(
        code: (original.customer?.selectedCovenant?.code ?? 0) + 999,
      );
      final updatedCustomer = original.customer?.copyWith(
        selectedCovenant: updatedCovenant,
      );
      final other = original.copyWith(customer: updatedCustomer);
      expect(original.needsProcessingComparedTo(other), isTrue);
    });

    test('should return true when seller code is different', () {
      final updatedSeller = original.seller?.copyWith(
        code: (original.seller?.code ?? 0) + 999,
      );
      final other = original.copyWith(seller: updatedSeller);
      expect(original.needsProcessingComparedTo(other), isTrue);
    });

    test('should return true when one of the products code is different', () {
      final originalProducts = original.products!;
      final updatedProduct = originalProducts.first.copyWith(
        code: originalProducts.first.code + 999,
      );
      final updatedProducts = [
        updatedProduct,
        ...originalProducts.sublist(1),
      ];
      final other = original.copyWith(products: updatedProducts);
      expect(original.needsProcessingComparedTo(other), isTrue);
    });

    test('should return true when products list length is different', () {
      final originalProducts = original.products!;
      final updatedProducts = originalProducts.sublist(1);
      final other = original.copyWith(products: updatedProducts);
      expect(original.needsProcessingComparedTo(other), isTrue);
    });
  });

  group('BSFSaleRequestEntity totalLiquidAndPaidDifference and isPaymentValid', () {
    test('should calculate difference correctly with exact matching values', () {
      final request = BSFSaleRequestEntity.empty().copyWith(
        products: [
          EntityFactory.makeBSFProductItemEntity().copyWith(
            quantity: 1.0,
            value: 100.0,
            annulDiscounts: true,
            annulIncrement: true,
            annulDeliveryTax: true,
          ),
        ],
        financials: [
          BSFFinancialEntity(
            paymentFinalizations: [
              EntityFactory.makeBSFPaymentFinalizationWrapperEntity().copyWith(
                value: 100.0,
              ),
            ],
            paybackValue: 0,
          ),
        ],
      );

      expect(request.totalLiquidAndPaidDifference, 0.0);
      expect(request.isPaymentValid, isTrue);
    });

    test('should calculate difference correctly when values are slightly off due to float inaccuracies', () {
      // 10.00 - 9.99 = 0.01
      // If we add a payment of 9.99 and a payment of 0.01, totalPayments should match products total 10.00
      final request = BSFSaleRequestEntity.empty().copyWith(
        products: [
          EntityFactory.makeBSFProductItemEntity().copyWith(
            quantity: 1.0,
            value: 10.00,
            annulDiscounts: true,
            annulIncrement: true,
            annulDeliveryTax: true,
          ),
        ],
        financials: [
          BSFFinancialEntity(
            paymentFinalizations: [
              EntityFactory.makeBSFPaymentFinalizationWrapperEntity().copyWith(
                value: 9.99,
              ),
              EntityFactory.makeBSFPaymentFinalizationWrapperEntity().copyWith(
                value: 0.01,
              ),
            ],
            paybackValue: 0,
          ),
        ],
      );

      // Due to double-precision arithmetic, 9.99 + 0.01 might be slightly off.
      // Cents conversion ensures it is treated as exactly 10.00.
      expect(request.totalLiquidAndPaidDifference, 0.0);
      expect(request.isPaymentValid, isTrue);
    });

    test('should calculate positive difference when payment is missing', () {
      final request = BSFSaleRequestEntity.empty().copyWith(
        products: [
          EntityFactory.makeBSFProductItemEntity().copyWith(
            quantity: 1.0,
            value: 100.0,
            annulDiscounts: true,
            annulIncrement: true,
            annulDeliveryTax: true,
          ),
        ],
        financials: [
          BSFFinancialEntity(
            paymentFinalizations: [
              EntityFactory.makeBSFPaymentFinalizationWrapperEntity().copyWith(
                value: 99.99,
              ),
            ],
            paybackValue: 0,
          ),
        ],
      );

      expect(request.totalLiquidAndPaidDifference, 0.01);
      expect(request.isPaymentValid, isFalse);
    });

    test('should calculate negative difference when payment exceeds total products', () {
      final request = BSFSaleRequestEntity.empty().copyWith(
        products: [
          EntityFactory.makeBSFProductItemEntity().copyWith(
            quantity: 1.0,
            value: 100.0,
            annulDiscounts: true,
            annulIncrement: true,
            annulDeliveryTax: true,
          ),
        ],
        financials: [
          BSFFinancialEntity(
            paymentFinalizations: [
              EntityFactory.makeBSFPaymentFinalizationWrapperEntity().copyWith(
                value: 100.01,
              ),
            ],
            paybackValue: 0,
          ),
        ],
      );

      expect(request.totalLiquidAndPaidDifference, -0.01);
      expect(request.isPaymentValid, isFalse);
    });
  });
}
