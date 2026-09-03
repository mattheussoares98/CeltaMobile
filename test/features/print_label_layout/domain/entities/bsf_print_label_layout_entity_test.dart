import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  group('field editor capabilities', () {
    final textField = EntityFactory.makeBSFPrintLabelLayoutFieldEntity();
    final barcodeField = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.barcode,
      ),
    );
    final imageField = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.logo,
      ),
    );
    final qrField = textField.copyWith(
      format: EntityFactory.makeBSFPrintLabelFieldFormatEntity(
        qrCodeType: true,
      ),
    );

    BSFPrintLabelLayoutEntity layout({
      required bool isGeneric,
      BSFLabelPrinterModelType modelType = BSFLabelPrinterModelType.zebraGC420t,
    }) => EntityFactory.makeBSFPrintLabelLayoutEntity(
      labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
        isGeneric: isGeneric,
        modelType: modelType,
      ),
    );

    test('should support alignment only for generic ordinary text', () {
      final genericLayout = layout(isGeneric: true);
      final specificLayout = layout(isGeneric: false);

      expect(genericLayout.supportsAlignment(textField), isTrue);
      expect(genericLayout.supportsAlignment(qrField), isFalse);
      expect(specificLayout.supportsAlignment(textField), isFalse);
    });

    test('should exclude unsupported printers from reverse text', () {
      expect(layout(isGeneric: false).supportsReverseText(textField), isTrue);
      expect(layout(isGeneric: true).supportsReverseText(textField), isFalse);
      expect(
        layout(isGeneric: false).supportsReverseText(barcodeField),
        isFalse,
      );
      expect(
        layout(
          isGeneric: false,
          modelType: BSFLabelPrinterModelType.os214Plus,
        ).supportsReverseText(textField),
        isFalse,
      );
      expect(
        layout(
          isGeneric: false,
          modelType: BSFLabelPrinterModelType.rabbitOS214,
        ).supportsReverseText(textField),
        isFalse,
      );
    });

    test('should support barcode ratio only for specific printers', () {
      final qrBarcode = barcodeField.copyWith(
        barcodeSimbologyType: BSFBarcodeSimbologyType.qrCode,
      );

      expect(
        layout(isGeneric: false).supportsBarcodeRatio(barcodeField),
        isTrue,
      );
      expect(
        layout(isGeneric: true).supportsBarcodeRatio(barcodeField),
        isFalse,
      );
      expect(layout(isGeneric: false).supportsBarcodeRatio(textField), isFalse);
      expect(layout(isGeneric: false).supportsBarcodeRatio(qrBarcode), isFalse);
    });

    test(
      'should support generic barcode controls only for generic barcodes',
      () {
        final qrBarcode = barcodeField.copyWith(
          barcodeSimbologyType: BSFBarcodeSimbologyType.qrCode,
        );

        expect(
          layout(isGeneric: true).supportsGenericBarcodeControls(barcodeField),
          isTrue,
        );
        expect(
          layout(isGeneric: true).supportsGenericBarcodeControls(qrBarcode),
          isFalse,
        );
        expect(
          layout(isGeneric: false).supportsGenericBarcodeControls(barcodeField),
          isFalse,
        );
        expect(
          layout(isGeneric: true).supportsGenericBarcodeControls(textField),
          isFalse,
        );
      },
    );

    test('should support text below barcode only for non-QR barcodes', () {
      final qrBarcode = barcodeField.copyWith(
        barcodeSimbologyType: BSFBarcodeSimbologyType.qrCode,
      );

      expect(
        layout(isGeneric: true).supportsDrawLabelBelowBarcode(barcodeField),
        isTrue,
      );
      expect(
        layout(isGeneric: true).supportsDrawLabelBelowBarcode(qrBarcode),
        isFalse,
      );
      expect(
        layout(isGeneric: false).supportsDrawLabelBelowBarcode(textField),
        isFalse,
      );
    });

    test('should restrict OS214 Plus image and QR rotation', () {
      final os214PlusLayout = layout(
        isGeneric: false,
        modelType: BSFLabelPrinterModelType.os214Plus,
      );

      expect(os214PlusLayout.supportsRotation(imageField), isFalse);
      expect(os214PlusLayout.supportsRotation(qrField), isFalse);
      expect(os214PlusLayout.supportsRotation(textField), isTrue);
      expect(layout(isGeneric: false).supportsRotation(imageField), isTrue);
      expect(layout(isGeneric: true).supportsRotation(imageField), isTrue);
      expect(
        layout(isGeneric: false).supportsRotation(
          EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
            field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
              fieldType: BSFPrintLabelFieldType.boxOrLine,
            ),
          ),
        ),
        isFalse,
      );
    });
  });
}
