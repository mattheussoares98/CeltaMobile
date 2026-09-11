import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../domain/services/services.dart';

class PrintLabelCanvasCaptureService {
  static const _maximumAttempts = 3;

  const PrintLabelCanvasCaptureService();

  Future<Uint8List> capture({
    required RenderRepaintBoundary boundary,
    required double pixelRatio,
  }) async {
    final diagnostics = <String>[];

    for (var attempt = 0; attempt < _maximumAttempts; attempt++) {
      final stopwatch = Stopwatch()..start();
      ui.Image? image;

      try {
        await _waitForFreshPaint(boundary);
        image = await boundary.toImage(pixelRatio: pixelRatio);
        final rawData = await image.toByteData();
        final hasVisibleContent =
            rawData != null &&
            const PrintLabelCanvasImageValidator().hasVisibleContent(
              rawData,
              width: image.width,
              height: image.height,
            );
        if (!hasVisibleContent) {
          diagnostics.add(
            _attemptDiagnostics(
              attempt: attempt,
              duration: stopwatch.elapsed,
              boundary: boundary,
              pixelRatio: pixelRatio,
              image: image,
              rawBytes: rawData?.lengthInBytes,
              result: 'blank image',
            ),
          );
          continue;
        }

        final pngData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (pngData != null) return pngData.buffer.asUint8List();

        diagnostics.add(
          _attemptDiagnostics(
            attempt: attempt,
            duration: stopwatch.elapsed,
            boundary: boundary,
            pixelRatio: pixelRatio,
            image: image,
            rawBytes: rawData.lengthInBytes,
            result: 'PNG encoding returned null',
          ),
        );
      } catch (error, stackTrace) {
        diagnostics.add(
          '${_attemptDiagnostics(attempt: attempt, duration: stopwatch.elapsed, boundary: boundary, pixelRatio: pixelRatio, image: image, result: 'capture exception')}\nError: $error\nStack trace:\n$stackTrace',
        );
      } finally {
        image?.dispose();
      }
    }

    throw StateError(
      'The canvas preview could not be captured after $_maximumAttempts attempts.\n\n'
      '${diagnostics.join('\n\n')}',
    );
  }

  Future<void> _waitForFreshPaint(RenderRepaintBoundary boundary) async {
    await WidgetsBinding.instance.endOfFrame;
    boundary.markNeedsPaint();
    WidgetsBinding.instance.ensureVisualUpdate();
    await WidgetsBinding.instance.endOfFrame;
  }

  String _attemptDiagnostics({
    required int attempt,
    required Duration duration,
    required RenderRepaintBoundary boundary,
    required double pixelRatio,
    required String result,
    ui.Image? image,
    int? rawBytes,
  }) {
    return <String>[
      'Attempt: ${attempt + 1}/$_maximumAttempts',
      'Result: $result',
      'Duration: ${duration.inMilliseconds} ms',
      'Boundary: ${boundary.size.width} x ${boundary.size.height}',
      'Attached: ${boundary.attached}',
      'Pixel ratio: $pixelRatio',
      if (image != null) 'Raster: ${image.width} x ${image.height}',
      if (rawBytes != null) 'Raw bytes: $rawBytes',
    ].join('\n');
  }
}
