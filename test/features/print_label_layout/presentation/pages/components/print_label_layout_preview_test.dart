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
