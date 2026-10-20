import 'package:celta_inventario/localization/localization.dart';
import 'dart:convert';

import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/details/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/mocks.dart';

void main() {
  testWidgets('should render logo width and height independently', (
    tester,
  ) async {
    final field =
        EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
          width: 40,
          height: 20,
          dimensionType: BSFPrintLabelFieldDimensionType.printerCommandValue,
          field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
            fieldType: BSFPrintLabelFieldType.logo,
          ),
        ).copyWith(
          previewImage: base64Decode(
            'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4z8DwHwAFgAI/ScL7WQAAAABJRU5ErkJggg==',
          ),
        );
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
        home: Align(
          child: PrintLabelPreviewElement(
            field: field,
            coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
            previewMetrics: PrintLabelPreviewMetrics(layout),
            scaleX: 2,
            scaleY: 3,
            isOutsideLabel: false,
            isInsideFilledBox: false,
          ),
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.fit, BoxFit.fill);
    expect(tester.getSize(find.byType(Image)), const Size(80, 60));
  });

  testWidgets('should identify a missing logo without forcing square bounds', (
    tester,
  ) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      width: 30,
      height: 10,
      dimensionType: BSFPrintLabelFieldDimensionType.printerCommandValue,
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.logo,
      ),
    );
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
        home: Align(
          child: PrintLabelPreviewElement(
            field: field,
            coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
            previewMetrics: PrintLabelPreviewMetrics(layout),
            scaleX: 1,
            scaleY: 1,
            isOutsideLabel: false,
            isInsideFilledBox: false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final placeholder = find.byWidgetPredicate(
      (widget) => widget is Semantics && widget.properties.label == 'Logotipo',
    );
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    expect(tester.getSize(placeholder), const Size(30, 10));
  });

  testWidgets('should show the formatted preview value from the API', (
    tester,
  ) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity().copyWith(
      positionStartCharacter: 1,
      maxCharacterSize: 2147483647,
    );
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
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

    final start = (field.positionStartCharacter - 1).clamp(
      0,
      field.previewValue!.length,
    );
    final end = (start + field.maxCharacterSize).clamp(
      start,
      field.previewValue!.length,
    );
    expect(
      find.text(field.previewValue!.substring(start, end)),
      findsOneWidget,
    );
    expect(find.text('${field.prefix}${field.field!.content}'), findsNothing);
  });

  testWidgets('should apply initial position and maximum characters', (
    tester,
  ) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      previewValue: 'ABCDEFG',
    ).copyWith(positionStartCharacter: 2, maxCharacterSize: 3);
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
        modelType: BSFLabelPrinterModelType.rabbitOS214,
      ),
      fields: [field],
    );
    final metrics = PrintLabelPreviewMetrics(layout);
    final fullField = field.copyWith(
      positionStartCharacter: 1,
      maxCharacterSize: 7,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
        home: PrintLabelPreviewElement(
          field: field,
          coordinateUnit: BSFPrintLabelCoordinateUnit.centimeter,
          previewMetrics: metrics,
          scaleX: 1,
          scaleY: 1,
          isOutsideLabel: false,
          isInsideFilledBox: false,
        ),
      ),
    );

    expect(find.text('BCD'), findsOneWidget);
    expect(
      metrics.renderedWidth(field, text: metrics.visiblePreviewText(field)),
      closeTo(
        metrics.renderedWidth(
              fullField,
              text: metrics.visiblePreviewText(fullField),
            ) *
            3 /
            7,
        0.001,
      ),
    );
  });

  testWidgets('should show the remaining text when maximum is zero', (
    tester,
  ) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      previewValue: 'ABCDEFG',
    ).copyWith(positionStartCharacter: 2, maxCharacterSize: 0);
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
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

    expect(find.text('BCDEFG'), findsOneWidget);
  });

  testWidgets('should render QR-code formats as a sized icon', (tester) async {
    final field =
        EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
          previewValue: 'ABCDEFG',
        ).copyWith(
          positionStartCharacter: 5,
          maxCharacterSize: 1,
          format: EntityFactory.makeBSFPrintLabelFieldFormatEntity(
            qrCodeType: true,
          ),
        );
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
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

    expect(find.byIcon(Icons.qr_code_2), findsOneWidget);
    expect(find.text('ABCDEFG'), findsNothing);
  });

  testWidgets('should render Rabbit native font magnification', (tester) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      width: 2,
      height: 2,
      dimensionType: BSFPrintLabelFieldDimensionType.scaleFactor,
      fontType: '3',
      fontSize: 0,
      previewValue: '2,45',
    ).copyWith(positionStartCharacter: 1, maxCharacterSize: 4);
    final printer = EntityFactory.makeBSFPrintLabelPrinterEntity(
      modelType: BSFLabelPrinterModelType.rabbitOS214,
    );
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      labelPrinter: printer,
      fields: [field],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
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

  testWidgets('should render Rabbit font type 6 as semibold', (tester) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      width: 1,
      height: 1,
      dimensionType: BSFPrintLabelFieldDimensionType.scaleFactor,
      fontType: '6',
      fontSize: 0,
      isBold: false,
      previewValue: '0,00',
    ).copyWith(positionStartCharacter: 1, maxCharacterSize: 4);
    final printer = EntityFactory.makeBSFPrintLabelPrinterEntity(
      modelType: BSFLabelPrinterModelType.rabbitOS214,
    );
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      labelPrinter: printer,
      fields: [field],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
        home: PrintLabelPreviewElement(
          field: field,
          coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
          previewMetrics: PrintLabelPreviewMetrics(layout),
          scaleX: 1,
          scaleY: 1,
          isOutsideLabel: false,
          isInsideFilledBox: false,
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('0,00'));
    expect(text.style?.fontWeight, FontWeight.w600);
  });

  testWidgets('should configure Rabbit EAN painter with its visible value', (
    tester,
  ) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      width: 2,
      height: 30,
      dimensionType: BSFPrintLabelFieldDimensionType.printerCommandValue,
      ratioBarCode: 1.5,
      drawLabelBelowBarcode: true,
      previewValue: '7891000379103',
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.barcode,
      ),
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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
        home: PrintLabelPreviewElement(
          field: field,
          coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
          previewMetrics: PrintLabelPreviewMetrics(layout),
          scaleX: 1,
          scaleY: 1,
          isOutsideLabel: false,
          isInsideFilledBox: false,
        ),
      ),
    );

    final element = find.byType(PrintLabelPreviewElement);
    final bars = find.descendant(
      of: element,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is PrintLabelBarcodePainter,
      ),
    );
    final semanticValue = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics && widget.properties.label == '7891000379103',
    );
    final painter =
        tester.widget<CustomPaint>(bars).painter as PrintLabelBarcodePainter;

    expect(bars, findsOneWidget);
    expect(semanticValue, findsOneWidget);
    expect(painter.value, '7891000379103');
    expect(painter.drawValue, isTrue);
    expect(painter.captionHeight, 8);
  });

  testWidgets('should configure OS214 Plus fallback barcode caption', (
    tester,
  ) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      width: 2,
      height: 60,
      dimensionType: BSFPrintLabelFieldDimensionType.printerCommandValue,
      fontType: '4',
      drawLabelBelowBarcode: true,
      previewValue: '00000017',
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.barcode,
      ),
    );
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
      labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
        modelType: BSFLabelPrinterModelType.os214Plus,
      ),
      fields: [field],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
        home: PrintLabelPreviewElement(
          field: field,
          coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
          previewMetrics: PrintLabelPreviewMetrics(layout),
          scaleX: 1,
          scaleY: 1,
          isOutsideLabel: false,
          isInsideFilledBox: false,
        ),
      ),
    );

    final painter =
        tester
                .widget<CustomPaint>(
                  find.descendant(
                    of: find.byType(PrintLabelPreviewElement),
                    matching: find.byType(CustomPaint),
                  ),
                )
                .painter
            as PrintLabelBarcodePainter;

    expect(painter.value, '00000017');
    expect(painter.drawValue, isTrue);
    expect(painter.captionHeight, 32.5);
  });

  testWidgets('should paint the outside indicator above a box', (tester) async {
    final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
      width: 100,
      height: 50,
      ratioBarCode: 25,
      field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
        fieldType: BSFPrintLabelFieldType.boxOrLine,
      ),
    );
    final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pt'),
        home: PrintLabelPreviewElement(
          field: field,
          coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
          previewMetrics: PrintLabelPreviewMetrics(layout),
          scaleX: 1,
          scaleY: 1,
          isOutsideLabel: true,
          isInsideFilledBox: false,
        ),
      ),
    );

    final outsideIndicator = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(Transform),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );

    expect(outsideIndicator.position, DecorationPosition.foreground);
    expect((outsideIndicator.decoration as BoxDecoration).border, isNotNull);
  });
}
