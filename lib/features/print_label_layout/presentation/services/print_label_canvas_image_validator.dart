import 'dart:typed_data';

class PrintLabelCanvasImageValidator {
  static const _minimumChannelDifference = 4;

  const PrintLabelCanvasImageValidator();

  bool hasVisibleContent(ByteData data) {
    if (data.lengthInBytes < 8) return false;

    final firstRed = data.getUint8(0);
    final firstGreen = data.getUint8(1);
    final firstBlue = data.getUint8(2);
    final firstAlpha = data.getUint8(3);

    for (var offset = 4; offset + 3 < data.lengthInBytes; offset += 4) {
      if ((data.getUint8(offset) - firstRed).abs() >=
              _minimumChannelDifference ||
          (data.getUint8(offset + 1) - firstGreen).abs() >=
              _minimumChannelDifference ||
          (data.getUint8(offset + 2) - firstBlue).abs() >=
              _minimumChannelDifference ||
          (data.getUint8(offset + 3) - firstAlpha).abs() >=
              _minimumChannelDifference) {
        return true;
      }
    }

    return false;
  }
}
