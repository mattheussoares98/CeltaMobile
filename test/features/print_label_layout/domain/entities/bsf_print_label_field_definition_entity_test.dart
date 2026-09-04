import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  test(
    'appliesTo should return the configured value for every layout type',
    () {
      final definition = EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        applyToCustomer: true,
        applyToCovenant: false,
        applyToProduct: true,
        applyToCustomerCard: false,
        applyToSaleBilling: true,
        applyToTransport: false,
        applyToSaleRequestProduct: true,
      );

      expect(definition.appliesTo(BSFPrintLabelLayoutType.customer), isTrue);
      expect(definition.appliesTo(BSFPrintLabelLayoutType.covenant), isFalse);
      expect(definition.appliesTo(BSFPrintLabelLayoutType.product), isTrue);
      expect(
        definition.appliesTo(BSFPrintLabelLayoutType.customerCard),
        isFalse,
      );
      expect(definition.appliesTo(BSFPrintLabelLayoutType.saleBilling), isTrue);
      expect(definition.appliesTo(BSFPrintLabelLayoutType.transport), isFalse);
      expect(
        definition.appliesTo(BSFPrintLabelLayoutType.saleRequestProduct),
        isTrue,
      );
    },
  );
}
