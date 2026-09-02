import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should expose the editor label for every alignment', () {
    expect(BSFPrintElementAlignmentType.left.label, 'Esquerda');
    expect(BSFPrintElementAlignmentType.middle.label, 'Centro');
    expect(BSFPrintElementAlignmentType.right.label, 'Direita');
  });
}
