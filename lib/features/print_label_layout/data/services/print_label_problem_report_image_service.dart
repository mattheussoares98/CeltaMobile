import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';

import 'package:celta_inventario/features/print_label_layout/data/services/services.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/services/services.dart';

typedef PhysicalPhotoEncoder =
    Future<Uint8List?> Function(String sourcePath, int quality);

class PrintLabelProblemReportImageService
    implements IPrintLabelProblemReportImageService {
  static const int maximumByteLength = 5 * 1024 * 1024;
  static const int physicalPhotoLongestEdge = 1920;
  static const int initialPhysicalPhotoQuality = 80;
  static const List<int> _physicalPhotoQualities = [80, 70, 60, 50, 40];

  final PhysicalPhotoEncoder _physicalPhotoEncoder;
  final Future<Directory> Function() _temporaryDirectoryProvider;

  PrintLabelProblemReportImageService({
    PhysicalPhotoEncoder? physicalPhotoEncoder,
    Future<Directory> Function()? temporaryDirectoryProvider,
  }) : _physicalPhotoEncoder = physicalPhotoEncoder ?? _encodePhysicalPhoto,
       _temporaryDirectoryProvider =
           temporaryDirectoryProvider ?? getTemporaryDirectory;

  @override
  Future<PrintLabelProblemReportPreparedImageEntity> preparePhysicalPhoto(
    String sourcePath,
  ) async {
    await _requireReadableFile(sourcePath);

    Uint8List? encoded;
    for (final quality in _physicalPhotoQualities) {
      encoded = await _physicalPhotoEncoder(sourcePath, quality);
      if (encoded != null && encoded.lengthInBytes <= maximumByteLength) break;
    }

    if (encoded == null || encoded.lengthInBytes > maximumByteLength) {
      throw const PrintLabelProblemReportImageException(
        'The physical photo could not be converted within the upload limit.',
      );
    }

    return _writePreparedImage(encoded, 'physical-label');
  }

  @override
  Future<PrintLabelProblemReportPreparedImageEntity> prepareCanvas(
    String sourcePath,
  ) async {
    await _requireReadableFile(sourcePath);
    final encoded = await Isolate.run(() => _encodeCanvas(sourcePath));
    if (encoded.lengthInBytes > maximumByteLength) {
      throw const PrintLabelProblemReportImageException(
        'The canvas preview exceeds the upload limit.',
      );
    }

    return _writePreparedImage(encoded, 'canvas-preview');
  }

  @override
  Future<List<int>> readBytes(String filePath) => File(filePath).readAsBytes();

  @override
  Future<void> cleanup(Iterable<String> filePaths) async {
    for (final filePath in filePaths.toSet()) {
      final file = File(filePath);
      if (await file.exists()) await file.delete();
    }
  }

  Future<PrintLabelProblemReportPreparedImageEntity> _writePreparedImage(
    Uint8List bytes,
    String prefix,
  ) async {
    final dimensions = _readWebpDimensions(bytes);
    final directory = await _temporaryDirectoryProvider();
    final file = File(
      '${directory.path}${Platform.pathSeparator}'
      '$prefix-${_randomSuffix()}.webp',
    );
    await file.writeAsBytes(bytes, flush: true);

    return PrintLabelProblemReportPreparedImageEntity(
      filePath: file.path,
      sha256: sha256.convert(bytes).toString(),
      metadata: PrintLabelProblemReportAttachmentMetadataEntity(
        byteLength: bytes.lengthInBytes,
        width: dimensions.$1,
        height: dimensions.$2,
      ),
    );
  }

  static Future<Uint8List?> _encodePhysicalPhoto(
    String sourcePath,
    int quality,
  ) async {
    final firstPass = await FlutterImageCompress.compressWithFile(
      sourcePath,
      minHeight: physicalPhotoLongestEdge,
      quality: quality,
      format: CompressFormat.webp,
    );
    if (firstPass == null || firstPass.isEmpty) return null;

    final dimensions = _readWebpDimensions(firstPass);
    final longestEdge = max(dimensions.$1, dimensions.$2);
    if (longestEdge <= physicalPhotoLongestEdge) return firstPass;

    final scale = physicalPhotoLongestEdge / longestEdge;
    return FlutterImageCompress.compressWithList(
      firstPass,
      minWidth: max(1, (dimensions.$1 * scale).round()),
      minHeight: max(1, (dimensions.$2 * scale).round()),
      quality: quality,
      autoCorrectionAngle: false,
      format: CompressFormat.webp,
    );
  }

  static Uint8List _encodeCanvas(String sourcePath) {
    final decoded = image.decodeImage(File(sourcePath).readAsBytesSync());
    if (decoded == null) {
      throw const PrintLabelProblemReportImageException(
        'The canvas preview is not a readable image.',
      );
    }
    return image.encodeWebP(image.bakeOrientation(decoded));
  }

  static (int, int) _readWebpDimensions(Uint8List bytes) {
    final info = image.WebPDecoder().startDecode(bytes);
    if (info == null || info.width <= 0 || info.height <= 0) {
      throw const PrintLabelProblemReportImageException(
        'The converted image is not a readable WebP file.',
      );
    }
    return (info.width, info.height);
  }

  static Future<void> _requireReadableFile(String path) async {
    final file = File(path);
    if (!await file.exists() || await file.length() == 0) {
      throw const PrintLabelProblemReportImageException(
        'The source image file is missing or empty.',
      );
    }
  }

  static String _randomSuffix() {
    final random = Random.secure();
    return List.generate(
      16,
      (_) => random.nextInt(256),
    ).map((value) => value.toRadixString(16).padLeft(2, '0')).join();
  }
}
