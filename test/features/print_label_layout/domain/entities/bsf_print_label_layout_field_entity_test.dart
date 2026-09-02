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
    expect(field.minimumEditorStrokeThickness, 1);
    expect(field.showsRotationEditor, isTrue);
    expect(field.usesTextCharacterOptions, isTrue);
    expect(field.editorFontType, 6);
  });

  test('should use stroke thickness as the box or line minimum size', () {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      ratioBarCode: 3,
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.boxOrLine,
      ),
    );

    expect(field.minimumEditorWidth, 3);
    expect(field.minimumEditorHeight, 3);
    expect(field.showsRotationEditor, isFalse);
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
}
