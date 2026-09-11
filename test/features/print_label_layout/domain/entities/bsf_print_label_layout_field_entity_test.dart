import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  test('should expose editor constraints for a text field', () {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      dimensionType: BSFPrintLabelFieldDimensionType.centimeter,
      fontType: '9',
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.string,
      ),
    );

    expect(field.minimumEditorWidth, 0.1);
    expect(field.minimumEditorHeight, 0.1);
    expect(field.minimumEditorStrokeThickness, 0.1);
    expect(field.showsRotationEditor, isTrue);
    expect(field.usesTextCharacterOptions, isTrue);
    expect(field.editorFontType, 6);
  });

  test('should use stroke thickness as the box or line minimum size', () {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      ratioBarCode: 0.3,
      dimensionType: BSFPrintLabelFieldDimensionType.centimeter,
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.boxOrLine,
      ),
    );

    expect(field.minimumEditorWidth, 0.3);
    expect(field.minimumEditorHeight, 0.3);
    expect(field.minimumEditorStrokeThickness, 0.1);
    expect(field.showsRotationEditor, isFalse);
  });

  test('should keep decimal stroke minimum for printer-dot fields', () {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      ratioBarCode: 0.3,
      dimensionType: BSFPrintLabelFieldDimensionType.printerDot,
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.boxOrLine,
      ),
    );

    expect(field.minimumEditorStrokeThickness, 0.1);
  });

  test('should return only formats applicable to the field type', () {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.integer,
      ),
    );
    final stringFormat = EntityFactory.makeBSFPrintLabelFieldFormatEntity();
    final integerFormat = EntityFactory.makeBSFPrintLabelFieldFormatEntity(
      stringType: false,
      integerType: true,
    );

    expect(field.applicableFormats([stringFormat, integerFormat]), [
      integerFormat,
    ]);
  });

  test('should support decimal places only for non-QR float fields', () {
    final floatField = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.float,
      ),
    );
    final qrFloatField = floatField.copyWith(
      format: EntityFactory.makeBSFPrintLabelFieldFormatEntity(
        floatType: true,
        qrCodeType: true,
      ),
    );
    final stringField = EntityFactory.makeBSFPrintLabelLayoutFieldEntity();

    expect(floatField.supportsDecimalPlaces, isTrue);
    expect(qrFloatField.supportsDecimalPlaces, isFalse);
    expect(stringField.supportsDecimalPlaces, isFalse);
  });

  test('should use one size control only for QR fields', () {
    final qrBarcode = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      barcodeSimbologyType: BSFBarcodeSimbologyType.qrCode,
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.barcode,
      ),
    );
    final qrFormat = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      format: EntityFactory.makeBSFPrintLabelFieldFormatEntity(
        qrCodeType: true,
      ),
    );
    final ordinaryField = EntityFactory.makeBSFPrintLabelLayoutFieldEntity();

    expect(qrBarcode.usesSingleSizeEditor, isTrue);
    expect(qrFormat.usesSingleSizeEditor, isTrue);
    expect(ordinaryField.usesSingleSizeEditor, isFalse);
  });
}
