import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  BSFPrintLabelLayoutEntity layout({
    int code = 1,
    BSFPrintLabelLayoutType layoutType = BSFPrintLabelLayoutType.product,
    BSFPrintLabelFormType formType = BSFPrintLabelFormType.paginated,
    bool isGeneric = false,
    BSFLabelPrinterModelType modelType = BSFLabelPrinterModelType.os214Plus,
    List<BSFPrintLabelLayoutFieldEntity>? fields,
    List<String>? speeds,
    List<String>? temperatures,
    List<BSFPrintLabelDirectionType>? directions,
  }) => EntityFactory.makeBSFPrintLabelLayoutEntity(
    code: code,
    layoutType: layoutType,
    formType: formType,
    fields: fields,
    labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
      isGeneric: isGeneric,
      modelType: modelType,
      supportedPrintSpeeds: speeds,
      supportedTemperatures: temperatures,
      supportedDirections: directions,
    ),
  );

  group('identity capabilities', () {
    test('should lock layout type and printer for an existing layout', () {
      final capabilities = layout().capabilities;

      expect(capabilities.canEditName, isTrue);
      expect(capabilities.canEditLayoutType, isFalse);
      expect(capabilities.canEditPrinter, isFalse);
    });

    test(
      'should allow printer selection only before a new layout has fields',
      () {
        expect(
          layout(code: 0, fields: const []).capabilities.canEditPrinter,
          isTrue,
        );
        expect(layout(code: 0).capabilities.canEditPrinter, isFalse);
      },
    );

    test('should expose address controls only for customer layouts', () {
      expect(
        layout(
          layoutType: BSFPrintLabelLayoutType.customer,
        ).capabilities.canEditAddressType,
        isTrue,
      );
      expect(
        layout(
          layoutType: BSFPrintLabelLayoutType.customerCard,
        ).capabilities.showsAddressType,
        isTrue,
      );
      expect(layout().capabilities.showsAddressType, isFalse);
    });
  });

  group('form and label capabilities', () {
    test('should apply generic printer rules', () {
      final capabilities = layout(isGeneric: true).capabilities;

      expect(capabilities.canEditFormType, isFalse);
      expect(capabilities.canEditFormHeight, isTrue);
      expect(capabilities.canEditLabelHeight, isTrue);
      expect(capabilities.canEditLabelBottomMargin, isTrue);
      expect(capabilities.canEditFormSizeConfiguration, isTrue);
      expect(capabilities.canEditDirection, isFalse);
    });

    test('should disable heights for a paginated specific printer', () {
      final capabilities = layout().capabilities;

      expect(capabilities.canEditFormType, isTrue);
      expect(capabilities.canEditFormHeight, isFalse);
      expect(capabilities.canEditLabelHeight, isFalse);
      expect(capabilities.canEditLabelBottomMargin, isFalse);
      expect(capabilities.canEditFormSizeConfiguration, isFalse);
    });

    test('should enable heights for a continuous specific printer', () {
      final capabilities = layout(
        formType: BSFPrintLabelFormType.continuous,
      ).capabilities;

      expect(capabilities.canEditFormHeight, isTrue);
      expect(capabilities.isFormHeightRequired, isTrue);
      expect(capabilities.canEditLabelHeight, isTrue);
      expect(capabilities.isLabelHeightRequired, isTrue);
    });

    test('should keep Zebra GC420t heights and direction editable', () {
      final capabilities = layout(
        modelType: BSFLabelPrinterModelType.zebraGC420t,
      ).capabilities;

      expect(capabilities.canEditFormHeight, isTrue);
      expect(capabilities.canEditLabelHeight, isTrue);
      expect(capabilities.canEditDirection, isTrue);
    });

    test('should cover every specific printer model branch', () {
      for (final modelType in BSFLabelPrinterModelType.values) {
        final capabilities = layout(
          isGeneric: modelType == BSFLabelPrinterModelType.generic,
          modelType: modelType,
        ).capabilities;
        final isGeneric = modelType == BSFLabelPrinterModelType.generic;
        final isZebra = modelType == BSFLabelPrinterModelType.zebraGC420t;

        expect(
          capabilities.canEditFormType,
          !isGeneric,
          reason: modelType.name,
        );
        expect(
          capabilities.canEditFormHeight,
          isGeneric || isZebra,
          reason: modelType.name,
        );
        expect(capabilities.canEditDirection, isZebra, reason: modelType.name);
        expect(
          capabilities.canEditTemperature,
          !isGeneric,
          reason: modelType.name,
        );
      }
    });
  });

  group('product and printer capabilities', () {
    test('should expose product controls by layout type', () {
      final product = layout().capabilities;
      final saleRequest = layout(
        layoutType: BSFPrintLabelLayoutType.saleRequestProduct,
      ).capabilities;
      final customer = layout(
        layoutType: BSFPrintLabelLayoutType.customer,
      ).capabilities;

      expect(product.showsProductPacking, isTrue);
      expect(product.showsQuantityPerProduct, isTrue);
      expect(product.showsPrintBySoldQuantity, isFalse);
      expect(saleRequest.showsPrintBySoldQuantity, isTrue);
      expect(saleRequest.showsBalanceBehavior, isTrue);
      expect(customer.showsProductPacking, isFalse);
      expect(customer.showsQuantityPerProduct, isFalse);
    });

    test('should cover every layout type branch', () {
      for (final layoutType in BSFPrintLabelLayoutType.values) {
        final capabilities = layout(layoutType: layoutType).capabilities;
        final isAddress =
            layoutType == BSFPrintLabelLayoutType.customer ||
            layoutType == BSFPrintLabelLayoutType.customerCard;
        final isProduct =
            layoutType == BSFPrintLabelLayoutType.product ||
            layoutType == BSFPrintLabelLayoutType.saleRequestProduct;
        final isSaleRequestProduct =
            layoutType == BSFPrintLabelLayoutType.saleRequestProduct;

        expect(
          capabilities.showsAddressType,
          isAddress,
          reason: layoutType.name,
        );
        expect(
          capabilities.showsProductPacking,
          isProduct,
          reason: layoutType.name,
        );
        expect(
          capabilities.showsQuantityPerProduct,
          isProduct,
          reason: layoutType.name,
        );
        expect(
          capabilities.showsPrintBySoldQuantity,
          isSaleRequestProduct,
          reason: layoutType.name,
        );
        expect(
          capabilities.showsBalanceBehavior,
          isSaleRequestProduct,
          reason: layoutType.name,
        );
      }
    });

    test('should enable printer settings only for specific printers', () {
      final specific = layout().capabilities;
      final generic = layout(isGeneric: true).capabilities;

      expect(specific.canEditTemperature, isTrue);
      expect(specific.canEditPrintSpeed, isTrue);
      expect(specific.canEditPackageInterval, isTrue);
      expect(generic.canEditTemperature, isFalse);
      expect(generic.canEditPrintSpeed, isFalse);
      expect(generic.canEditPackageInterval, isFalse);
    });

    test('should expose server-supported values unchanged', () {
      const speeds = ['1', '6', '30'];
      const temperatures = ['0', '12', '27'];
      const directions = [
        BSFPrintLabelDirectionType.right,
        BSFPrintLabelDirectionType.left,
      ];
      final capabilities = layout(
        speeds: speeds,
        temperatures: temperatures,
        directions: directions,
      ).capabilities;

      expect(identical(capabilities.supportedPrintSpeeds, speeds), isTrue);
      expect(
        identical(capabilities.supportedTemperatures, temperatures),
        isTrue,
      );
      expect(identical(capabilities.supportedDirections, directions), isTrue);
    });
  });
}
