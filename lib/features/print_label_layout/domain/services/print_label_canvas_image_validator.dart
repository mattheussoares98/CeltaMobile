import 'dart:math' as math;
import 'dart:typed_data';

class PrintLabelCanvasImageValidator {
  static const _minimumChannelDifference = 24;
  static const _sampleCountPerAxis = 8;

  const PrintLabelCanvasImageValidator();

  bool hasVisibleContent(
    ByteData data, {
    required int width,
    required int height,
  }) {
    if (width < 3 || height < 3 || data.lengthInBytes < width * height * 4) {
      return false;
    }

    final inset = math.max(1, (math.min(width, height) * 0.04).round());
    final left = inset;
    final top = inset;
    final right = width - inset;
    final bottom = height - inset;
    if (left >= right || top >= bottom) return false;

    final background = _dominantSampleColor(
      data,
      width: width,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
    final interiorPixelCount = (right - left) * (bottom - top);
    final requiredContrastingPixels = math.min(
      math.max(8, interiorPixelCount ~/ 5000),
      math.max(1, interiorPixelCount ~/ 4),
    );
    var contrastingPixels = 0;

    for (var y = top; y < bottom; y++) {
      for (var x = left; x < right; x++) {
        final offset = ((y * width) + x) * 4;
        if (_differsFrom(data, offset, background)) {
          contrastingPixels++;
          if (contrastingPixels >= requiredContrastingPixels) return true;
        }
      }
    }

    return false;
  }

  int _dominantSampleColor(
    ByteData data, {
    required int width,
    required int left,
    required int top,
    required int right,
    required int bottom,
  }) {
    final occurrences = <int, int>{};
    final horizontalStep = math.max(1, (right - left) ~/ _sampleCountPerAxis);
    final verticalStep = math.max(1, (bottom - top) ~/ _sampleCountPerAxis);

    for (var y = top; y < bottom; y += verticalStep) {
      for (var x = left; x < right; x += horizontalStep) {
        final color = data.getUint32(((y * width) + x) * 4);
        occurrences[color] = (occurrences[color] ?? 0) + 1;
      }
    }

    return occurrences.entries
        .reduce((current, next) => next.value > current.value ? next : current)
        .key;
  }

  bool _differsFrom(ByteData data, int offset, int background) {
    return (data.getUint8(offset) - ((background >> 24) & 0xff)).abs() >=
            _minimumChannelDifference ||
        (data.getUint8(offset + 1) - ((background >> 16) & 0xff)).abs() >=
            _minimumChannelDifference ||
        (data.getUint8(offset + 2) - ((background >> 8) & 0xff)).abs() >=
            _minimumChannelDifference ||
        (data.getUint8(offset + 3) - (background & 0xff)).abs() >=
            _minimumChannelDifference;
  }
}
