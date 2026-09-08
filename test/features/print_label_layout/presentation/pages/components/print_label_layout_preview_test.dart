import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/details/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/mocks.dart';

void main() {
  const canvasKey = ValueKey('print-label-preview-canvas');

  testWidgets('should resize the canvas when label width changes', (
    tester,
  ) async {
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      labelWidth: 100,
      labelHeight: 50,
      labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
        modelType: BSFLabelPrinterModelType.eltron,
      ),
    );

    await _pumpPreview(tester, layout);
    final initialSize = tester.getSize(find.byKey(canvasKey));

    await _pumpPreview(tester, layout.copyWith(labelWidth: 50));
    final resized = tester.getSize(find.byKey(canvasKey));

    expect(resized.width, lessThan(initialSize.width));
    expect(resized.height, greaterThan(initialSize.height));
    expect(resized.aspectRatio, 1);
  });

  testWidgets('should resize the canvas when label height changes', (
    tester,
  ) async {
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      labelWidth: 100,
      labelHeight: 100,
      labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
        modelType: BSFLabelPrinterModelType.eltron,
      ),
    );

    await _pumpPreview(tester, layout);
    final initialSize = tester.getSize(find.byKey(canvasKey));

    await _pumpPreview(tester, layout.copyWith(labelHeight: 50));
    final resized = tester.getSize(find.byKey(canvasKey));

    expect(resized.width, greaterThan(initialSize.width));
    expect(resized.height, lessThan(initialSize.height));
    expect(resized.aspectRatio, 2);
  });

  testWidgets(
    'should not request a height when paginated layout height is undefined',
    (tester) async {
      final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        formType: BSFPrintLabelFormType.paginated,
        labelWidth: 100,
        labelHeight: 0,
        formHeight: 0,
        fields: const [],
        labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
          modelType: BSFLabelPrinterModelType.eltron,
        ),
      );

      await _pumpPreview(tester, layout);

      expect(
        find.text(
          'Adicione campos para determinar a altura da pré-visualização',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Informe uma largura e altura válidas para visualizar a etiqueta',
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'should paint filled boxes first without changing the field indexes',
    (tester) async {
      final text = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        code: 16,
        coordinateX: 78,
        coordinateY: 159,
        field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
          fieldType: BSFPrintLabelFieldType.string,
        ),
      );
      final filledBox = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        code: 15,
        coordinateX: 57,
        coordinateY: 35,
        width: 535,
        height: 288,
        ratioBarCode: 172,
        dimensionType: BSFPrintLabelFieldDimensionType.printerDot,
        field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
          fieldType: BSFPrintLabelFieldType.boxOrLine,
        ),
      );
      final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        formWidth: 767,
        formHeight: 426,
        labelWidth: 604,
        labelHeight: 401,
        fields: [text, filledBox],
        labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
          modelType: BSFLabelPrinterModelType.os214Plus,
        ),
      );

      await _pumpPreview(tester, layout);

      final paintedFieldCodes = tester
          .widgetList<PrintLabelPreviewElement>(
            find.byType(PrintLabelPreviewElement),
          )
          .map((element) => element.field.code)
          .toList();
      expect(paintedFieldCodes, [15, 16]);
      expect(layout.fields, [text, filledBox]);
    },
  );

  testWidgets('should report every rotated field outside the canvas', (
    tester,
  ) async {
    final rotations = {
      BSFPrintElementRotationType.rotate90: (x: 5.0, y: 20.0),
      BSFPrintElementRotationType.rotate180: (x: 10.0, y: 20.0),
      BSFPrintElementRotationType.rotate270: (x: 20.0, y: 10.0),
    };

    for (final rotation in rotations.entries) {
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        coordinateX: rotation.value.x,
        coordinateY: rotation.value.y,
        width: 15,
        height: 10,
        rotateType: rotation.key,
        dimensionType: BSFPrintLabelFieldDimensionType.centimeter,
      );
      final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
        labelWidth: 100,
        labelHeight: 50,
        fields: [field],
        labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
          modelType: BSFLabelPrinterModelType.eltron,
        ),
      );

      await _pumpPreview(tester, layout);

      expect(
        tester
            .widget<PrintLabelPreviewElement>(
              find.byType(PrintLabelPreviewElement),
            )
            .isOutsideLabel,
        isTrue,
        reason: '${rotation.key.name} should exceed the canvas',
      );
    }
  });
}

Future<void> _pumpPreview(
  WidgetTester tester,
  BSFPrintLabelLayoutEntity layout,
) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 300,
        height: 250,
        child: PrintLabelLayoutPreview(layout: layout),
      ),
    ),
  ),
);
