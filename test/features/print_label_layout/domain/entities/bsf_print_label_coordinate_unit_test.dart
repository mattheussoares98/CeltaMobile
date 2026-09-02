import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should expose editor metadata for each coordinate unit', () {
    expect(BSFPrintLabelCoordinateUnit.centimeter.label, 'cm');
    expect(BSFPrintLabelCoordinateUnit.centimeter.editorStep, 0.1);
    expect(BSFPrintLabelCoordinateUnit.centimeter.format(2), '2.0');
    expect(BSFPrintLabelCoordinateUnit.printerDot.label, 'pontos');
    expect(BSFPrintLabelCoordinateUnit.printerDot.editorStep, 1);
    expect(BSFPrintLabelCoordinateUnit.printerDot.format(2), '2');
    expect(BSFPrintLabelCoordinateUnit.printerDot.format(2.5), '2.5');
  });
}
