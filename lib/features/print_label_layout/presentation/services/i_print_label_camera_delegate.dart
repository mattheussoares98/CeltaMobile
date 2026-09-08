import 'package:flutter/widgets.dart';

abstract interface class IPrintLabelCameraDelegate {
  Future<void> initialize();

  Widget buildPreview();

  Future<String> takePicture();

  Future<void> pause();

  Future<void> resume();

  bool isPermissionDenied(Object error);

  Future<void> dispose();
}
