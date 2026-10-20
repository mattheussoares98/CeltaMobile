import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:camera/camera.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/services/services.dart';
import 'package:flutter/widgets.dart';

class PrintLabelCameraDelegate implements IPrintLabelCameraDelegate {
  CameraController? _controller;

  @override
  Future<void> initialize() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw AppException.localized(CoreFailure.noCameraAvailableFailure);
    }
    final controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller = controller;
    await controller.initialize();
  }

  @override
  Widget buildPreview() => CameraPreview(_controller!);

  @override
  Future<String> takePicture() async => (await _controller!.takePicture()).path;

  @override
  Future<void> pause() => _disposeController();

  @override
  Future<void> resume() => initialize();

  @override
  bool isPermissionDenied(Object error) =>
      error is CameraException &&
      const {
        'CameraAccessDenied',
        'CameraAccessDeniedWithoutPrompt',
        'CameraAccessRestricted',
      }.contains(error.code);

  @override
  Future<void> dispose() => _disposeController();

  Future<void> _disposeController() async {
    final controller = _controller;
    _controller = null;
    await controller?.dispose();
  }
}
