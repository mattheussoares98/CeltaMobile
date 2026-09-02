import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should expose editor metadata for each dimension type', () {
    expect(BSFPrintLabelFieldDimensionType.notApplicable.label, '');
    expect(BSFPrintLabelFieldDimensionType.centimeter.label, 'cm');
    expect(BSFPrintLabelFieldDimensionType.centimeter.editorStep, 0.1);
    expect(BSFPrintLabelFieldDimensionType.centimeter.format(2), '2.0');
    expect(BSFPrintLabelFieldDimensionType.printerDot.label, 'pontos');
    expect(BSFPrintLabelFieldDimensionType.scaleFactor.label, 'fator');
    expect(
      BSFPrintLabelFieldDimensionType.printerCommandValue.label,
      'valor do comando',
    );
    expect(BSFPrintLabelFieldDimensionType.printerDot.editorStep, 1);
    expect(BSFPrintLabelFieldDimensionType.printerDot.format(2), '2');
  });
}
