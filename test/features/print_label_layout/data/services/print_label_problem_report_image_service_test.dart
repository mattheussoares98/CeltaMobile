import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;

import 'package:celta_inventario/features/print_label_layout/data/services/services.dart';

void main() {
  late Directory temporaryDirectory;
  late File sourceFile;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'print-label-image-service-test-',
    );
    sourceFile = File(
      '${temporaryDirectory.path}${Platform.pathSeparator}'
      'source.png',
    );
    await sourceFile.writeAsBytes(_makePng());
  });

  tearDown(() async {
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('preparePhysicalPhoto starts at quality 80, retries the size limit, and '
      'returns readable metadata and SHA-256', () async {
    final qualities = <int>[];
    final webp = _makeWebp();
    final service = PrintLabelProblemReportImageService(
      physicalPhotoEncoder: (path, quality) async {
        expect(path, sourceFile.path);
        qualities.add(quality);
        if (quality == 80) {
          return Uint8List(
            PrintLabelProblemReportImageService.maximumByteLength + 1,
          );
        }
        return webp;
      },
      temporaryDirectoryProvider: () async => temporaryDirectory,
    );

    final result = await service.preparePhysicalPhoto(sourceFile.path);

    expect(qualities, [80, 70]);
    expect(result.metadata.byteLength, webp.lengthInBytes);
    expect(result.metadata.width, 8);
    expect(result.metadata.height, 4);
    expect(result.sha256, sha256.convert(webp).toString());
    expect(await File(result.filePath).readAsBytes(), webp);
  });

  test('preparePhysicalPhoto rejects output that remains over 5 MiB', () async {
    final service = PrintLabelProblemReportImageService(
      physicalPhotoEncoder: (_, _) async =>
          Uint8List(PrintLabelProblemReportImageService.maximumByteLength + 1),
      temporaryDirectoryProvider: () async => temporaryDirectory,
    );

    await expectLater(
      service.preparePhysicalPhoto(sourceFile.path),
      throwsA(isA<PrintLabelProblemReportImageException>()),
    );
  });

  test(
    'prepareCanvas creates a readable lossless WebP without changing pixels',
    () async {
      final service = PrintLabelProblemReportImageService(
        temporaryDirectoryProvider: () async => temporaryDirectory,
      );
      final stopwatch = Stopwatch()..start();

      final result = await service.prepareCanvas(sourceFile.path);
      stopwatch.stop();
      final bytes = await File(result.filePath).readAsBytes();
      final decoded = image.decodeWebP(bytes)!;

      expect(result.metadata.width, 8);
      expect(result.metadata.height, 4);
      expect(result.metadata.byteLength, bytes.lengthInBytes);
      expect(result.sha256, sha256.convert(bytes).toString());
      final pixel = decoded.getPixel(3, 2);
      expect([pixel.r, pixel.g, pixel.b, pixel.a], [30, 80, 130, 255]);
      expect(stopwatch.elapsed, lessThan(const Duration(seconds: 5)));
    },
  );

  test(
    'cleanup deletes unique existing files and ignores missing files',
    () async {
      final service = PrintLabelProblemReportImageService(
        temporaryDirectoryProvider: () async => temporaryDirectory,
      );
      final first = File(
        '${temporaryDirectory.path}${Platform.pathSeparator}a',
      );
      final second = File(
        '${temporaryDirectory.path}${Platform.pathSeparator}b',
      );
      await first.writeAsString('a');
      await second.writeAsString('b');

      await service.cleanup([first.path, first.path, second.path, 'missing']);

      expect(await first.exists(), isFalse);
      expect(await second.exists(), isFalse);
    },
  );

  test('both preparation methods reject missing source files', () async {
    final service = PrintLabelProblemReportImageService(
      temporaryDirectoryProvider: () async => temporaryDirectory,
    );
    final missing =
        '${temporaryDirectory.path}${Platform.pathSeparator}missing';

    await expectLater(
      service.preparePhysicalPhoto(missing),
      throwsA(isA<PrintLabelProblemReportImageException>()),
    );
    await expectLater(
      service.prepareCanvas(missing),
      throwsA(isA<PrintLabelProblemReportImageException>()),
    );
  });
}

Uint8List _makePng() {
  final source = image.Image(width: 8, height: 4);
  source.clear(image.ColorRgb8(30, 80, 130));
  return image.encodePng(source);
}

Uint8List _makeWebp() {
  final source = image.Image(width: 8, height: 4);
  source.clear(image.ColorRgb8(30, 80, 130));
  return image.encodeWebP(source);
}
