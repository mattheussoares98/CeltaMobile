import 'package:flutter/material.dart';

class PrintLabelBarcodePainter extends CustomPainter {
  final Color color;

  const PrintLabelBarcodePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const pattern = <double>[1, 2, 1, 1, 3, 1, 2, 2, 1, 3];
    final unit = size.width / 24;
    var x = 0.0;

    for (var index = 0; x < size.width; index++) {
      final width = pattern[index % pattern.length] * unit;
      if (index.isEven) {
        canvas.drawRect(
          Rect.fromLTWH(x, 0, width.clamp(0, size.width - x), size.height),
          paint,
        );
      }
      x += width;
    }
  }

  @override
  bool shouldRepaint(PrintLabelBarcodePainter oldDelegate) =>
      oldDelegate.color != color;
}
