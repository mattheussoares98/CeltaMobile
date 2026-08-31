import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';

class PrintLabelBarcodePainter extends CustomPainter {
  final Color color;
  final String value;
  final double captionHeight;
  final bool drawValue;

  const PrintLabelBarcodePainter({
    required this.color,
    required this.value,
    required this.captionHeight,
    required this.drawValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final encodedValue = const PrintLabelEan13Encoder().encode(value);
    if (encodedValue == null) {
      _paintFallback(canvas, size);
      return;
    }

    _paintEan13(canvas, size, encodedValue);
  }

  void _paintEan13(Canvas canvas, Size size, String encodedValue) {
    final paint = Paint()..color = color;
    final effectiveCaptionHeight = drawValue
        ? captionHeight.clamp(0.0, size.height).toDouble()
        : 0.0;
    final barHeight = size.height - effectiveCaptionHeight;
    final firstDigitWidth = drawValue ? effectiveCaptionHeight * 0.75 : 0.0;
    final moduleWidth = (size.width - firstDigitWidth) / encodedValue.length;
    final extendedBarHeight = barHeight + (effectiveCaptionHeight * 0.35);

    for (var index = 0; index < encodedValue.length; index++) {
      if (encodedValue[index] != '1') continue;

      canvas.drawRect(
        Rect.fromLTWH(
          firstDigitWidth + (index * moduleWidth),
          0,
          moduleWidth,
          _isGuardModule(index) ? extendedBarHeight : barHeight,
        ),
        paint,
      );
    }

    if (!drawValue) return;

    _paintCenteredText(
      canvas,
      value[0],
      Rect.fromLTWH(0, barHeight, firstDigitWidth, effectiveCaptionHeight),
      effectiveCaptionHeight,
    );
    _paintSpacedText(
      canvas,
      value.substring(1, 7),
      Rect.fromLTWH(
        firstDigitWidth + (3 * moduleWidth),
        barHeight,
        42 * moduleWidth,
        effectiveCaptionHeight,
      ),
      effectiveCaptionHeight,
    );
    _paintSpacedText(
      canvas,
      value.substring(7),
      Rect.fromLTWH(
        firstDigitWidth + (50 * moduleWidth),
        barHeight,
        42 * moduleWidth,
        effectiveCaptionHeight,
      ),
      effectiveCaptionHeight,
    );
  }

  void _paintSpacedText(
    Canvas canvas,
    String text,
    Rect area,
    double fontSize,
  ) {
    final characterWidth = area.width / text.length;
    for (var index = 0; index < text.length; index++) {
      _paintCenteredText(
        canvas,
        text[index],
        Rect.fromLTWH(
          area.left + (index * characterWidth),
          area.top,
          characterWidth,
          area.height,
        ),
        fontSize,
      );
    }
  }

  void _paintFallback(Canvas canvas, Size size) {
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

  void _paintCenteredText(
    Canvas canvas,
    String text,
    Rect area,
    double fontSize,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontFamily: 'monospace',
          fontSize: fontSize,
          height: 1,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: area.width);
    painter.paint(
      canvas,
      Offset(
        area.left + ((area.width - painter.width) / 2),
        area.top + ((area.height - painter.height) / 2),
      ),
    );
  }

  bool _isGuardModule(int index) =>
      index == 0 ||
      index == 2 ||
      index == 46 ||
      index == 48 ||
      index == 92 ||
      index == 94;

  @override
  bool shouldRepaint(PrintLabelBarcodePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.value != value ||
      oldDelegate.captionHeight != captionHeight ||
      oldDelegate.drawValue != drawValue;
}
