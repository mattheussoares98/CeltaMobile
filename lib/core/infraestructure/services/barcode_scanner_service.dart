import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:celta_inventario/utils/utils.dart';

/// PERFORMANCE: In Flutter, camera scanning is a 'Device Capability'.
/// While traditionally called a 'Datasource', this acts as an
/// Infrastructure Service because it is inherently linked to the UI.
class BarcodeScannerService {
  BarcodeScannerService._();

  /// Triggers the scanner UI and returns the result.
  /// PERFORMANCE: Using showModalBottomSheet keeps the app state alive
  /// and avoids the heavy Activity-switch overhead of previous plugins.
  static Future<String?> scanBarcode(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      // PERFORMANCE: Using UseRootNavigator=true ensures the bottom sheet
      // is not blocked by local navigation logic.
      useRootNavigator: true,
      builder: (context) => const _BarcodeScannerWidget(),
    );
    return result;
  }
}

/// PERFORMANCE: Extracted the UI into a private widget to ensure
/// that only the camera portion rebuilds during a scan session.
class _BarcodeScannerWidget extends StatefulWidget {
  const _BarcodeScannerWidget();

  @override
  State<_BarcodeScannerWidget> createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<_BarcodeScannerWidget> {
  // PERFORMANCE: Managing the controller locally ensures memory
  // is released immediately when the widget is disposed.
  late final MobileScannerController _controller;
  bool _isScanned = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.85,
      child: Stack(
        children: [
          // PERFORMANCE: RepaintBoundary isolates the high-frequency camera
          // texture updates from the rest of the UI overlay.
          RepaintBoundary(
            child: MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                if (_isScanned) return;

                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  _isScanned = true;
                  final code = barcodes.first.rawValue;
                  debugPrint('Scanner: Success [$code]');

                  context.pop(code);
                }
              },
            ),
          ),

          // UI Overlays
          const _ScannerOverlay(),

          // Header Actions
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.flash_on, color: Colors.white),
                  onPressed: () => _controller.toggleTorch(),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: context.pop,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: ShapeDecoration(
          shape: QrScannerOverlayShape(
            borderColor: context.theme.primaryColor,
            borderRadius: 12,
            borderLength: 30,
            borderWidth: 8,
            cutOutSize: 260,
          ),
        ),
      ),
    );
  }
}

/// PERFORMANCE: Optimized overlay painter using a single Path calculation
/// to minimize GPU draw calls per frame.
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 1.0,
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final double boxWidth = cutOutSize;
    final double boxHeight = cutOutSize;

    final paint = Paint()
      ..color = Colors.black.withAlpha(150)
      ..style = PaintingStyle.fill;

    // PERFORMANCE: Using PathOperation.difference is much more efficient than
    // drawing 4 separate dark boxes around the center hole.
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(rect),
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(width / 2, height / 2),
              width: boxWidth,
              height: boxHeight,
            ),
            Radius.circular(borderRadius),
          ),
        ),
      ),
      paint,
    );

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = borderWidth;

    final double halfWidth = boxWidth / 2;
    final double halfHeight = boxHeight / 2;
    final double centerX = width / 2;
    final double centerY = height / 2;

    // Draw the 4 corners using a single loop or path for better performance
    final path = Path()
      // Top Left
      ..moveTo(centerX - halfWidth, centerY - halfHeight + borderLength)
      ..lineTo(centerX - halfWidth, centerY - halfHeight)
      ..lineTo(centerX - halfWidth + borderLength, centerY - halfHeight)
      // Top Right
      ..moveTo(centerX + halfWidth - borderLength, centerY - halfHeight)
      ..lineTo(centerX + halfWidth, centerY - halfHeight)
      ..lineTo(centerX + halfWidth, centerY - halfHeight + borderLength)
      // Bottom Right
      ..moveTo(centerX + halfWidth, centerY + halfHeight - borderLength)
      ..lineTo(centerX + halfWidth, centerY + halfHeight)
      ..lineTo(centerX + halfWidth - borderLength, centerY + halfHeight)
      // Bottom Left
      ..moveTo(centerX - halfWidth + borderLength, centerY + halfHeight)
      ..lineTo(centerX - halfWidth, centerY + halfHeight)
      ..lineTo(centerX - halfWidth, centerY + halfHeight - borderLength);

    canvas.drawPath(path, borderPaint);
  }

  @override
  ShapeBorder scale(double t) => this;
}
