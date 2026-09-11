import 'dart:typed_data';

import 'package:celta_inventario/features/print_label_layout/presentation/services/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const validator = PrintLabelCanvasImageValidator();

  test('should reject a uniform white canvas', () {
    final pixels = Uint8List.fromList([255, 255, 255, 255, 255, 255, 255, 255]);

    expect(validator.hasVisibleContent(ByteData.sublistView(pixels)), isFalse);
  });

  test('should accept a canvas containing visible contrast', () {
    final pixels = Uint8List.fromList([255, 255, 255, 255, 0, 0, 0, 255]);

    expect(validator.hasVisibleContent(ByteData.sublistView(pixels)), isTrue);
  });
}
