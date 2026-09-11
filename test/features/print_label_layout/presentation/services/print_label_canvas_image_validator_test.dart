import 'dart:typed_data';

import 'package:celta_inventario/features/print_label_layout/domain/services/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const validator = PrintLabelCanvasImageValidator();

  test('should reject a uniform white canvas', () {
    final pixels = _whiteCanvas(width: 20, height: 20);

    expect(
      validator.hasVisibleContent(
        ByteData.sublistView(pixels),
        width: 20,
        height: 20,
      ),
      isFalse,
    );
  });

  test('should accept a canvas containing visible contrast', () {
    final pixels = _whiteCanvas(width: 20, height: 20);
    for (var pixel = 0; pixel < 8; pixel++) {
      _setPixel(pixels, width: 20, x: 5 + pixel, y: 10, value: 0);
    }

    expect(
      validator.hasVisibleContent(
        ByteData.sublistView(pixels),
        width: 20,
        height: 20,
      ),
      isTrue,
    );
  });

  test('should reject a canvas containing only a contrasting border', () {
    final pixels = _whiteCanvas(width: 20, height: 20);
    for (var coordinate = 0; coordinate < 20; coordinate++) {
      _setPixel(pixels, width: 20, x: coordinate, y: 0, value: 0);
      _setPixel(pixels, width: 20, x: coordinate, y: 19, value: 0);
      _setPixel(pixels, width: 20, x: 0, y: coordinate, value: 0);
      _setPixel(pixels, width: 20, x: 19, y: coordinate, value: 0);
    }

    expect(
      validator.hasVisibleContent(
        ByteData.sublistView(pixels),
        width: 20,
        height: 20,
      ),
      isFalse,
    );
  });
}

Uint8List _whiteCanvas({required int width, required int height}) {
  final pixels = Uint8List(width * height * 4);
  for (var offset = 0; offset < pixels.length; offset += 4) {
    pixels.fillRange(offset, offset + 4, 255);
  }
  return pixels;
}

void _setPixel(
  Uint8List pixels, {
  required int width,
  required int x,
  required int y,
  required int value,
}) {
  final offset = ((y * width) + x) * 4;
  pixels[offset] = value;
  pixels[offset + 1] = value;
  pixels[offset + 2] = value;
}
