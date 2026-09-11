import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'print_label_canvas_image_validator.dart';

class PrintLabelCanvasCaptureService {
  static const _maximumAttempts = 3;

  const PrintLabelCanvasCaptureService();

  Future<Uint8List> capture({
    required RenderRepaintBoundary boundary,
    required double pixelRatio,
  }) async {
    for (var attempt = 0; attempt < _maximumAttempts; attempt++) {
      await _waitForFreshPaint(boundary);
      final image = await boundary.toImage(pixelRatio: pixelRatio);

      try {
        final rawData = await image.toByteData();
        if (rawData == null ||
            !const PrintLabelCanvasImageValidator().hasVisibleContent(
              rawData,
            )) {
          continue;
        }

        final pngData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (pngData != null) return pngData.buffer.asUint8List();
      } finally {
        image.dispose();
      }
    }

    throw StateError('The preview was captured without visible content');
  }

  Future<void> _waitForFreshPaint(RenderRepaintBoundary boundary) async {
    await WidgetsBinding.instance.endOfFrame;
    boundary.markNeedsPaint();
    WidgetsBinding.instance.ensureVisualUpdate();
    await WidgetsBinding.instance.endOfFrame;
  }
}
