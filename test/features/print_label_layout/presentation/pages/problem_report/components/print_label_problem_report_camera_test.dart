import 'dart:io';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/problem_report/components/components.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakePrintLabelCameraDelegate implements IPrintLabelCameraDelegate {
  Object? initializationError;
  late String photoPath;
  int takePictureCalls = 0;
  int disposeCalls = 0;

  @override
  Widget buildPreview() => const ColoredBox(color: Colors.black);

  @override
  Future<void> dispose() async => disposeCalls++;

  @override
  Future<void> initialize() async {
    if (initializationError != null) throw initializationError!;
  }

  @override
  bool isPermissionDenied(Object error) => error == initializationError;

  @override
  Future<void> pause() async {}

  @override
  Future<void> resume() async {}

  @override
  Future<String> takePicture() async {
    takePictureCalls++;
    return photoPath;
  }
}

void main() {
  testWidgets('shows camera permission guidance and disposes the delegate', (
    tester,
  ) async {
    final delegate = FakePrintLabelCameraDelegate()
      ..initializationError = Exception('permission denied');

    await tester.pumpWidget(
      MaterialApp(
        home: PrintLabelProblemReportCamera(
          cameraDelegate: delegate,
          onPhotoConfirmed: (_) {},
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('Permita o acesso'), findsOneWidget);
    expect(find.text('Abrir configurações'), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    expect(delegate.disposeCalls, 1);
  });

  testWidgets('requires every confirmation and allows a photo retake', (
    tester,
  ) async {
    final directory = Directory.systemTemp.createTempSync('label-camera-');
    addTearDown(() => directory.deleteSync(recursive: true));
    final photo = File('${directory.path}${Platform.pathSeparator}photo.png');
    photo.writeAsBytesSync(_onePixelPng);
    final delegate = FakePrintLabelCameraDelegate()..photoPath = photo.path;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrintLabelProblemReportCamera(
            cameraDelegate: delegate,
            onPhotoConfirmed: (_) {},
          ),
        ),
      ),
    );
    await tester.pump();

    ElevatedButton captureButton() =>
        tester.widget(find.widgetWithText(ElevatedButton, 'Fotografar'));
    expect(captureButton().onPressed, isNull);

    for (final checkbox in find.byType(BaseCheckBox).evaluate().toList()) {
      await tester.tap(find.byWidget(checkbox.widget));
      await tester.pump();
    }
    expect(captureButton().onPressed, isNotNull);

    await tester.tap(find.text('Fotografar'));
    await tester.pump();
    expect(find.byKey(const Key('print-label-photo-review')), findsOneWidget);

    await tester.tap(find.text('Tirar outra foto'));
    await tester.pump();
    expect(find.text('Fotografar'), findsOneWidget);
    expect(delegate.takePictureCalls, 1);
  });
}

const _onePixelPng = <int>[
  137,
  80,
  78,
  71,
  13,
  10,
  26,
  10,
  0,
  0,
  0,
  13,
  73,
  72,
  68,
  82,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  1,
  8,
  6,
  0,
  0,
  0,
  31,
  21,
  196,
  137,
  0,
  0,
  0,
  13,
  73,
  68,
  65,
  84,
  8,
  215,
  99,
  248,
  207,
  192,
  240,
  31,
  0,
  5,
  0,
  1,
  255,
  137,
  153,
  61,
  29,
  0,
  0,
  0,
  0,
  73,
  69,
  78,
  68,
  174,
  66,
  96,
  130,
];
