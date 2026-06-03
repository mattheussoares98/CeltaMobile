// test/features/sale_request/domain/entities/bsf/bsf_sale_request_entity_test.dart
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
}
