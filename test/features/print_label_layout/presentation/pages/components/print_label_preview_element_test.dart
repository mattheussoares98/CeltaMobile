import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/mocks.dart';

void main() {
  testWidgets('should show the formatted preview value from the API', (
    tester,
  ) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity();
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]);

    await tester.pumpWidget(
      MaterialApp(
        home: PrintLabelPreviewElement(
          field: field,
          coordinateUnit: BSFPrintLabelCoordinateUnit.centimeter,
          previewMetrics: PrintLabelPreviewMetrics(layout),
          scaleX: 1,
          scaleY: 1,
          isOutsideLabel: false,
          isInsideFilledBox: false,
        ),
      ),
    );

    expect(find.text(field.previewValue!), findsOneWidget);
    expect(find.text('${field.prefix}${field.field!.content}'), findsNothing);
  });

  testWidgets('should render Rabbit native font magnification', (tester) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      width: 2,
      height: 2,
      dimensionType: BSFPrintLabelFieldDimensionType.scaleFactor,
      fontType: '3',
      fontSize: 0,
      previewValue: '2,45',
    );
    final printer = EntityFactory.makeBSFPrintLabelPrinterEntity(
      modelType: BSFLabelPrinterModelType.rabbitOS214,
    );
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      labelPrinter: printer,
      fields: [field],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: PrintLabelPreviewElement(
          field: field,
          coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
          previewMetrics: PrintLabelPreviewMetrics(layout),
          scaleX: 1,
          scaleY: 1,
          isOutsideLabel: false,
          isInsideFilledBox: true,
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('2,45'));
    final colorScheme = Theme.of(tester.element(find.text('2,45'))).colorScheme;
    expect(text.style?.fontSize, 36);
    expect(text.style?.fontFamily, 'monospace');
    expect(text.style?.color, colorScheme.surface);
  });
}
