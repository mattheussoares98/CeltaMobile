import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import '../../../../mocks/mocks.dart';

void main() {
  group('date-time preview format', () {
    const formats = {
      7: 'dd/MM/yy',
      8: 'dd/MM/yyyy',
      9: 'MM/dd/yy',
      10: 'MM/dd/yyyy',
      11: 'yy/MM/dd',
      12: 'yyyy/MM/dd',
      13: 'ddMMyy',
      14: 'ddMMyyyy',
      15: 'MMddyy',
      16: 'MMddyyyy',
      17: 'yyMMdd',
      18: 'yyyyMMdd',
      19: 'HH:mm:ss',
      20: 'HH:mm',
      21: 'HHmmss',
      22: 'HHmm',
    };

    for (final entry in formats.entries) {
      test('should apply format code ${entry.key}', () {
        final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
          previewValue: '2026-09-02T14:05:09',
          field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
            fieldType: BSFPrintLabelFieldType.dateTime,
          ),
          format: EntityFactory.makeBSFPrintLabelFieldFormatEntity(
            code: entry.key,
            dateTimeType: true,
          ),
        );
        final metrics = PrintLabelPreviewMetrics(
          EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]),
        );

        final before = DateFormat(entry.value).format(DateTime.now());
        final previewText = metrics.previewText(field);
        final after = DateFormat(entry.value).format(DateTime.now());

        expect(previewText, anyOf(before, after));
      });
    }

    test('should preserve the preview value for an unsupported format', () {
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        previewValue: 'invalid date',
        field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
          fieldType: BSFPrintLabelFieldType.dateTime,
        ),
        format: EntityFactory.makeBSFPrintLabelFieldFormatEntity(
          code: 1,
          dateTimeType: true,
        ),
      );
      final metrics = PrintLabelPreviewMetrics(
        EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]),
      );

      expect(metrics.previewText(field), 'invalid date');
    });
  });

  group('float preview format', () {
    test('should apply the configured decimal places', () {
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        quantityDecimalPlaces: 3,
        previewValue: '5,55',
        field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
          fieldType: BSFPrintLabelFieldType.float,
        ),
      );
      final metrics = PrintLabelPreviewMetrics(
        EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]),
      );

      expect(metrics.previewText(field), '5,550');
    });

    test('should preserve the prefix while applying decimal places', () {
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        quantityDecimalPlaces: 0,
        previewValue: r'R$ 5,55',
        field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
          fieldType: BSFPrintLabelFieldType.float,
        ),
      ).copyWith(prefix: r'R$ ');
      final metrics = PrintLabelPreviewMetrics(
        EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]),
      );

      expect(metrics.previewText(field), r'R$ 5,55');
    });

    test(
      'should preserve supplied decimals when no reformatting is requested',
      () {
        final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
          quantityDecimalPlaces: 0,
          previewValue: '8,6',
          field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
            fieldType: BSFPrintLabelFieldType.float,
          ),
        );
        final metrics = PrintLabelPreviewMetrics(
          EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]),
        );

        expect(metrics.previewText(field), '8,6');
      },
    );
  });

  group('QR-code preview size', () {
    test('should reproduce the UI size for generic printers', () {
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        height: 1,
        dimensionType: BSFPrintLabelFieldDimensionType.centimeter,
        format: EntityFactory.makeBSFPrintLabelFieldFormatEntity(
          qrCodeType: true,
        ),
      );
      final metrics = PrintLabelPreviewMetrics(
        EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]),
      );

      expect(metrics.qrCodeRenderedSize(field), closeTo(1.190625, 0.000001));
    });

    test('should reproduce the UI size for specific printers', () {
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        height: 2,
        dimensionType: BSFPrintLabelFieldDimensionType.scaleFactor,
        format: EntityFactory.makeBSFPrintLabelFieldFormatEntity(
          qrCodeType: true,
        ),
      );
      final metrics = PrintLabelPreviewMetrics(
        EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]),
      );

      expect(metrics.qrCodeRenderedSize(field), 90);
    });

    test('should use UI midpoint-to-even rounding', () {
      final field = EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
        height: 2.5,
        dimensionType: BSFPrintLabelFieldDimensionType.scaleFactor,
        format: EntityFactory.makeBSFPrintLabelFieldFormatEntity(
          qrCodeType: true,
        ),
      );
      final metrics = PrintLabelPreviewMetrics(
        EntityFactory.makeBSFPrintLabelLayoutEntity(fields: [field]),
      );

      expect(metrics.qrCodeRenderedSize(field), 90);
    });
  });

  group('PrintLabelPreviewMetrics', () {
    test('should reproduce OS214 Plus native layout metrics', () {
      final bottomText = _os214PlusField(
        coordinateX: 40,
        coordinateY: 20,
        previewValue: 'POTE:',
      );
      final barcode = _os214PlusField(
        coordinateX: 600,
        coordinateY: 20,
        width: 2,
        height: 60,
        fontType: '4',
        previewValue: '00000017',
        fieldType: BSFPrintLabelFieldType.barcode,
      );
      final description = _os214PlusField(
        coordinateX: 40,
        coordinateY: 240,
        fontType: '4',
        previewValue: 'Descrição Completa do',
      );
      final metrics = _os214PlusMetrics([bottomText, barcode, description]);

      expect(metrics.canvasHeight, 292.5);
      expect(metrics.verticalPosition(description), 20);
      expect(metrics.verticalPosition(bottomText), 257.5);
      expect(metrics.verticalPosition(barcode), 185);
      expect(metrics.horizontalPosition(bottomText), 20);
      expect(metrics.horizontalPosition(barcode), 580);
      expect(metrics.renderedWidth(barcode), 162);
      expect(metrics.renderedWidth(bottomText), 62.5);
    });

    test('should apply OS214 Plus scalable font-size changes', () {
      final small = _os214PlusField(fontType: '9', fontSize: 6);
      final large = _os214PlusField(fontType: '9', fontSize: 18);
      final metrics = _os214PlusMetrics([small]);

      expect(
        metrics.renderedHeight(large),
        greaterThan(metrics.renderedHeight(small)),
      );
      expect(
        metrics.renderedWidth(large),
        greaterThan(metrics.renderedWidth(small)),
      );
    });

    test('should identify text inside an OS214 Plus filled box', () {
      final box = _os214PlusField(
        coordinateX: 20,
        coordinateY: 40,
        width: 500,
        height: 450,
        ratioBarCode: 225,
        fieldType: BSFPrintLabelFieldType.boxOrLine,
      );
      final inside = _os214PlusField(
        coordinateX: 65,
        coordinateY: 130,
        previewValue: '5,55',
      );
      final outside = _os214PlusField(
        coordinateX: 600,
        coordinateY: 130,
        previewValue: '0,19',
      );
      final metrics = _os214PlusMetrics([box, inside, outside]);

      expect(metrics.isFilledBox(box), isTrue);
      expect(metrics.isInsideFilledBox(inside), isTrue);
      expect(metrics.isInsideFilledBox(outside), isFalse);
    });

    test('should prefer configured label dimensions', () {
      final metrics = PrintLabelPreviewMetrics(
        EntityFactory.makeBSFPrintLabelLayoutEntity(
          labelWidth: 120,
          labelHeight: 60,
          formWidth: 300,
          formHeight: 200,
          labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
            modelType: BSFLabelPrinterModelType.eltron,
          ),
        ),
      );

      expect(metrics.effectiveLabelWidth, 120);
      expect(metrics.effectiveLabelHeight, 60);
      expect(metrics.canvasWidth, 120);
      expect(metrics.canvasHeight, 60);
    });

    test(
      'should fall back to form dimensions when label dimensions are zero',
      () {
        final metrics = PrintLabelPreviewMetrics(
          EntityFactory.makeBSFPrintLabelLayoutEntity(
            labelWidth: 0,
            labelHeight: 0,
            formWidth: 300,
            formHeight: 200,
          ),
        );

        expect(metrics.effectiveLabelWidth, 300);
        expect(metrics.effectiveLabelHeight, 200);
        expect(metrics.canvasWidth, 300);
        expect(metrics.canvasHeight, 200);
      },
    );

    test('should report zero canvas dimensions when no size is configured', () {
      final metrics = PrintLabelPreviewMetrics(
        EntityFactory.makeBSFPrintLabelLayoutEntity(
          labelWidth: 0,
          labelHeight: 0,
          formWidth: 0,
          formHeight: 0,
          fields: const [],
        ),
      );

      expect(metrics.effectiveLabelWidth, 0);
      expect(metrics.effectiveLabelHeight, 0);
      expect(metrics.canvasWidth, 0);
      expect(metrics.canvasHeight, 0);
    });

    test('should derive height when legacy dimensions are both absent', () {
      final field = _rabbitField(coordinateY: 20, height: 2);
      final metrics = PrintLabelPreviewMetrics(
        EntityFactory.makeBSFPrintLabelLayoutEntity(
          labelWidth: 780,
          labelHeight: 0,
          formHeight: 0,
          labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
            modelType: BSFLabelPrinterModelType.rabbitOS214,
          ),
          fields: [field],
        ),
      );

      expect(metrics.canvasHeight, 76);
    });

    test('should preserve the configured Rabbit boundary for thin boxes', () {
      final box = _rabbitField(
        coordinateX: 20,
        coordinateY: 5,
        width: 190,
        height: 40,
        ratioBarCode: 75,
        fieldType: BSFPrintLabelFieldType.boxOrLine,
      );
      final description = _rabbitField(coordinateX: 20, coordinateY: 85);
      final trailingText = _rabbitField(
        coordinateX: 378,
        coordinateY: 30,
        fontType: '2',
        previewValue: 'UN',
      );
      final metrics = _metrics([box, description, trailingText]);

      expect(metrics.canvasWidth, closeTo(429, 0.001));
      expect(metrics.drawableCanvasWidth, metrics.canvasWidth);
      expect(metrics.canvasHeight, 108);
    });

    test('should apply Rabbit native font dimensions and magnification', () {
      final field = _rabbitField(width: 2, height: 2, previewValue: '2,45');
      final metrics = _metrics([field]);

      expect(metrics.renderedWidth(field), 64);
      expect(metrics.renderedHeight(field), 36);
      expect(metrics.rabbitFontSize(field, 0.5), 18);
    });

    test('should use visible characters for Rabbit bounds', () {
      final field = _rabbitField(
        coordinateX: 100,
        previewValue: 'ABCDEFG',
      ).copyWith(positionStartCharacter: 2, maxCharacterSize: 3);
      final metrics = _metrics([field]);

      expect(
        metrics.exceedsRabbitBounds(
          field,
          drawableWidth: 130,
          previewHeight: metrics.canvasHeight,
        ),
        isFalse,
      );
      expect(
        metrics.horizontalPosition(field) + metrics.renderedWidth(field),
        greaterThan(130),
      );
    });

    test('should use Rabbit EAN modules and configured barcode height', () {
      final field = _rabbitField(
        coordinateX: 40,
        coordinateY: 8,
        width: 2,
        height: 30,
        ratioBarCode: 1.5,
        drawLabelBelowBarcode: true,
        previewValue: '7891000379103',
        fieldType: BSFPrintLabelFieldType.barcode,
      );
      final metrics = _metrics([field]);

      expect(metrics.renderedWidth(field), closeTo(123.913, 0.001));
      expect(metrics.renderedHeight(field), 38);
      expect(metrics.rabbitBarcodeCaptionFontSize(1), 8);
    });

    test('should preserve Rabbit multi-column label and barcode widths', () {
      final barcode = _rabbitField(
        coordinateX: 5,
        coordinateY: 5,
        width: 2,
        height: 10,
        ratioBarCode: 4,
        previewValue: '00000017',
        fieldType: BSFPrintLabelFieldType.barcode,
      );
      final printer = EntityFactory.makeBSFPrintLabelPrinterEntity(
        modelType: BSFLabelPrinterModelType.rabbitOS214,
        coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
      );
      final metrics = PrintLabelPreviewMetrics(
        EntityFactory.makeBSFPrintLabelLayoutEntity(
          formWidth: 500,
          formHeight: 0,
          quantityColumns: 3,
          labelWidth: 140,
          labelHeight: 0,
          labelPrinter: printer,
          fields: [barcode],
        ),
      );

      expect(metrics.canvasWidth, 140);
      expect(metrics.drawableCanvasWidth, closeTo(128.8, 0.001));
      expect(metrics.renderedWidth(barcode), closeTo(73.7, 0.001));
      expect(
        metrics.exceedsRabbitBounds(
          barcode,
          drawableWidth: metrics.drawableCanvasWidth,
          previewHeight: metrics.canvasHeight,
        ),
        isFalse,
      );
    });

    test(
      'should dynamically scale barcode renderedWidth when width changes',
      () {
        final fieldWidth2 = _rabbitField(
          width: 2,
          height: 30,
          ratioBarCode: 1.5,
          previewValue: '7891000379103',
          fieldType: BSFPrintLabelFieldType.barcode,
        );
        final fieldWidth3 = fieldWidth2.copyWith(width: 3);
        final fieldWidth1 = fieldWidth2.copyWith(width: 1);
        final metrics2 = _metrics([fieldWidth2]);
        final metrics3 = _metrics([fieldWidth3]);
        final metrics1 = _metrics([fieldWidth1]);

        expect(metrics2.renderedWidth(fieldWidth2), closeTo(123.913, 0.001));
        expect(metrics3.renderedWidth(fieldWidth3), closeTo(185.870, 0.001));
        expect(metrics1.renderedWidth(fieldWidth1), closeTo(61.957, 0.001));
      },
    );

    test('should keep large Rabbit price font horizontally condensed', () {
      final field = _rabbitField(fontType: '6', previewValue: '0,00');
      final metrics = _metrics([field]);

      expect(metrics.renderedWidth(field), 44);
      expect(metrics.renderedHeight(field), 48);
    });

    test(
      'should keep the Rabbit currency indicator narrower than its height',
      () {
        final field = _rabbitField(
          width: 6,
          height: 6,
          fontType: '1',
          previewValue: 'R\$',
        );
        final metrics = _metrics([field]);

        expect(metrics.renderedWidth(field), 36);
        expect(metrics.renderedHeight(field), 42);
      },
    );

    test('should correct the Rabbit currency indicator glyph origin', () {
      final currency = _rabbitField(
        coordinateX: 220,
        coordinateY: 26,
        width: 6,
        height: 6,
        fontType: '1',
        previewValue: 'R\$',
      );
      final price = _rabbitField(
        coordinateX: 290,
        coordinateY: 30,
        fontType: '6',
        previewValue: '0,00',
      );
      final metrics = _metrics([currency, price]);
      final currencyBottom =
          metrics.verticalPosition(currency) + metrics.renderedHeight(currency);
      final priceBottom =
          metrics.verticalPosition(price) + metrics.renderedHeight(price);

      expect(metrics.horizontalPosition(currency), 232);
      expect(metrics.horizontalPosition(price), 290);
      expect(currencyBottom, priceBottom);
    });

    test('should identify a filled Rabbit box and overlapping text', () {
      final box = _rabbitField(
        coordinateX: 20,
        coordinateY: 5,
        width: 190,
        height: 40,
        ratioBarCode: 75,
        fieldType: BSFPrintLabelFieldType.boxOrLine,
      );
      final inside = _rabbitField(coordinateX: 25, coordinateY: 13);
      final insideExpandedThickness = _rabbitField(
        coordinateX: 25,
        coordinateY: 65,
      );
      final outside = _rabbitField(coordinateX: 222, coordinateY: 30);
      final metrics = _metrics([box, inside, insideExpandedThickness, outside]);

      expect(metrics.isFilledBox(box), isTrue);
      expect(metrics.renderedHeight(box), 75);
      expect(metrics.isInsideFilledBox(inside), isTrue);
      expect(metrics.isInsideFilledBox(insideExpandedThickness), isTrue);
      expect(metrics.isInsideFilledBox(outside), isFalse);

      final hiddenBox = box.copyWith(isVisible: false);
      final hiddenMetrics = _metrics([hiddenBox, inside]);
      expect(hiddenMetrics.isInsideFilledBox(inside), isFalse);
    });

    test(
      'should move only a font-4 price inside a filled box to the right',
      () {
        final box = _rabbitField(
          coordinateX: 210,
          coordinateY: 40,
          width: 190,
          height: 150,
          ratioBarCode: 75,
          fieldType: BSFPrintLabelFieldType.boxOrLine,
        );
        final insidePrice = _rabbitField(
          coordinateX: 275,
          coordinateY: 80,
          fontType: '4',
          previewValue: '0,00',
          fieldType: BSFPrintLabelFieldType.float,
        );
        final outsidePrice = _rabbitField(
          coordinateX: 35,
          coordinateY: 80,
          fontType: '4',
          previewValue: '0,19',
          fieldType: BSFPrintLabelFieldType.float,
        );
        final metrics = _metrics([box, insidePrice, outsidePrice]);

        expect(metrics.horizontalPosition(insidePrice), 285);
        expect(metrics.horizontalPosition(outsidePrice), 35);
      },
    );

    test('should trim only the right edges of a full Rabbit box layout', () {
      final leadingText = _rabbitField(coordinateX: 20, coordinateY: 227);
      final box = _rabbitField(
        coordinateX: 210,
        coordinateY: 40,
        width: 190,
        height: 150,
        ratioBarCode: 75,
        fieldType: BSFPrintLabelFieldType.boxOrLine,
      );
      final metrics = _metrics([leadingText, box]);

      expect(metrics.canvasWidth, closeTo(429, 0.001));
      expect(metrics.drawableCanvasWidth, closeTo(420, 0.001));
      expect(metrics.renderedWidth(box), 190);
      expect(metrics.renderedHeight(box), 150);
      expect(metrics.horizontalPosition(box), 210);
    });

    test('should keep a shrunken Rabbit boundary and report overflow', () {
      final box = _rabbitField(
        coordinateX: 210,
        coordinateY: 40,
        width: 190,
        height: 150,
        ratioBarCode: 75,
        fieldType: BSFPrintLabelFieldType.boxOrLine,
      );
      final metrics = _metrics([box], labelWidth: 600);

      expect(metrics.canvasWidth, 330);
      expect(metrics.drawableCanvasWidth, 330);
      expect(
        metrics.exceedsRabbitBounds(
          box,
          drawableWidth: metrics.drawableCanvasWidth,
          previewHeight: metrics.canvasHeight,
        ),
        isTrue,
      );
    });

    test(
      'should convert Rabbit lower-left Y coordinates to Flutter positions',
      () {
        final box = _rabbitField(
          coordinateX: 20,
          coordinateY: 5,
          width: 190,
          height: 40,
          ratioBarCode: 75,
          fieldType: BSFPrintLabelFieldType.boxOrLine,
        );
        final ean = _rabbitField(
          coordinateX: 250,
          coordinateY: 13,
          fontType: '2',
        );
        final retail = _rabbitField(coordinateX: 270, coordinateY: 65);
        final description = _rabbitField(coordinateX: 20, coordinateY: 85);
        final metrics = _metrics([box, ean, retail, description]);

        expect(
          metrics.verticalPosition(retail),
          lessThan(metrics.verticalPosition(ean)),
        );
        expect(
          metrics.verticalPosition(description),
          lessThan(metrics.verticalPosition(box)),
        );
      },
    );

    test('should keep Rabbit 270-degree Y anchored across layouts', () {
      final date = _rabbitField(
        coordinateX: 5,
        coordinateY: 20,
        fontType: '2',
        previewValue: '02/09/26',
        rotateType: BSFPrintElementRotationType.rotate270,
      ).copyWith(positionStartCharacter: 1, maxCharacterSize: 0);
      final plu = _rabbitField(
        coordinateX: 400,
        coordinateY: 20,
        fontType: '2',
        previewValue: '000017',
        rotateType: BSFPrintElementRotationType.rotate270,
      ).copyWith(positionStartCharacter: 1, maxCharacterSize: 0);
      final barcode = _rabbitField(
        coordinateX: 280,
        coordinateY: 20,
        width: 2,
        height: 30,
        ratioBarCode: 1.5,
        drawLabelBelowBarcode: true,
        previewValue: '7891000379103',
        fieldType: BSFPrintLabelFieldType.barcode,
      );
      final detailedMetrics = _metrics([date, barcode, plu], labelWidth: 840);
      final reducedPlu = plu.copyWith(coordinateX: 5);
      final reducedMetrics = _metrics([
        reducedPlu,
        _rabbitField(coordinateX: 15, coordinateY: 25, width: 2, height: 2),
        _rabbitField(coordinateX: 15, coordinateY: 85),
      ], labelWidth: 840);

      expect(detailedMetrics.horizontalPosition(date), 0);
      expect(
        detailedMetrics.horizontalPosition(plu),
        plu.coordinateX + detailedMetrics.renderedHeight(plu),
      );
      expect(
        detailedMetrics.canvasHeight - detailedMetrics.verticalPosition(plu),
        plu.coordinateY + (detailedMetrics.renderedHeight(plu) / 4),
      );
      expect(
        reducedMetrics.canvasHeight -
            reducedMetrics.verticalPosition(reducedPlu),
        reducedPlu.coordinateY +
            (reducedMetrics.renderedHeight(reducedPlu) / 4),
      );
      expect(detailedMetrics.drawableCanvasWidth, closeTo(436.8, 0.001));
      expect(
        detailedMetrics.exceedsRabbitBounds(
          plu,
          drawableWidth: detailedMetrics.drawableCanvasWidth,
          previewHeight: detailedMetrics.canvasHeight,
        ),
        isFalse,
      );
    });
  });

  group('Zebra GC420t metrics', () {
    test('uses EPL form width instead of the unused label width', () {
      final metrics = _zebraMetrics(const []);

      expect(metrics.canvasWidth, 880);
      expect(metrics.canvasHeight, 220);
    });

    test('uses built-in EPL font dimensions and multipliers', () {
      final field = _zebraField(
        fontType: '4',
        width: 4,
        height: 3,
        previewValue: '0,00',
      );
      final metrics = _zebraMetrics([field]);

      expect(metrics.renderedWidth(field), 224);
      expect(metrics.renderedHeight(field), 72);
    });

    test('uses the EPL EAN-13 module width and caption height', () {
      final field = _zebraField(
        width: 2,
        height: 50,
        previewValue: '7891000379103',
        fieldType: BSFPrintLabelFieldType.barcode,
        drawLabelBelowBarcode: true,
      );
      final metrics = _zebraMetrics([field]);

      expect(metrics.renderedWidth(field), 190);
      expect(metrics.renderedHeight(field), 70);
    });

    test('applies Zebra logo scale factors to bitmap dimensions', () {
      final bitmapHeader = List<int>.filled(26, 0)
        ..[0] = 0x42
        ..[1] = 0x4D
        ..[18] = 189
        ..[22] = 201;
      final field = _zebraField(
        width: 0.5,
        height: 0.5,
        fieldType: BSFPrintLabelFieldType.logo,
      ).copyWith(previewImage: bitmapHeader);
      final metrics = _zebraMetrics([field]);

      expect(metrics.zebraLogoWidth(field), 94.5);
      expect(metrics.zebraLogoHeight(field), 100.5);
    });

    test('does not apply Zebra dimensions to another printer model', () {
      final field = _zebraField(width: 4, height: 3, previewValue: '0,00');
      final layout = _zebraMetrics([field]).layout.copyWith(
        labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
          modelType: BSFLabelPrinterModelType.eltron,
          coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
        ),
      );
      final metrics = PrintLabelPreviewMetrics(layout);

      expect(metrics.canvasWidth, 600);
      expect(metrics.renderedWidth(field), 4);
      expect(metrics.renderedHeight(field), 3);
    });
  });
}

PrintLabelPreviewMetrics _zebraMetrics(
  List<BSFPrintLabelLayoutFieldEntity> fields,
) => PrintLabelPreviewMetrics(
  EntityFactory.makeBSFPrintLabelLayoutEntity(
    formWidth: 880,
    formHeight: 220,
    labelWidth: 600,
    labelHeight: 0,
    labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
      modelType: BSFLabelPrinterModelType.zebraGC420t,
      coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
    ),
    fields: fields,
  ),
);

BSFPrintLabelLayoutFieldEntity _zebraField({
  double width = 1,
  double height = 1,
  String fontType = '3',
  String previewValue = 'Texto',
  BSFPrintLabelFieldType fieldType = BSFPrintLabelFieldType.string,
  bool drawLabelBelowBarcode = false,
}) => EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
  width: width,
  height: height,
  dimensionType: BSFPrintLabelFieldDimensionType.scaleFactor,
  fontType: fontType,
  fontSize: 0,
  previewValue: previewValue,
  drawLabelBelowBarcode: drawLabelBelowBarcode,
  field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
    fieldType: fieldType,
  ),
);

PrintLabelPreviewMetrics _os214PlusMetrics(
  List<BSFPrintLabelLayoutFieldEntity> fields,
) => PrintLabelPreviewMetrics(
  EntityFactory.makeBSFPrintLabelLayoutEntity(
    formWidth: 800,
    formHeight: 0,
    labelWidth: 800,
    labelHeight: 0,
    labelPrinter: EntityFactory.makeBSFPrintLabelPrinterEntity(
      modelType: BSFLabelPrinterModelType.os214Plus,
      coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
    ),
    fields: fields,
  ),
);

BSFPrintLabelLayoutFieldEntity _os214PlusField({
  double coordinateX = 0,
  double coordinateY = 0,
  double width = 1,
  double height = 1,
  double ratioBarCode = 0,
  String fontType = '2',
  int fontSize = 0,
  String previewValue = 'Texto',
  BSFPrintLabelFieldType fieldType = BSFPrintLabelFieldType.string,
}) => EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
  coordinateX: coordinateX,
  coordinateY: coordinateY,
  width: width,
  height: height,
  ratioBarCode: ratioBarCode,
  dimensionType: BSFPrintLabelFieldDimensionType.scaleFactor,
  fontType: fontType,
  fontSize: fontSize,
  previewValue: previewValue,
  drawLabelBelowBarcode: fieldType == BSFPrintLabelFieldType.barcode,
  field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
    fieldType: fieldType,
  ),
);

PrintLabelPreviewMetrics _metrics(
  List<BSFPrintLabelLayoutFieldEntity> fields, {
  double labelWidth = 780,
}) {
  final printer = EntityFactory.makeBSFPrintLabelPrinterEntity(
    modelType: BSFLabelPrinterModelType.rabbitOS214,
    coordinateUnit: BSFPrintLabelCoordinateUnit.printerDot,
  );
  final layout = EntityFactory.makeBSFPrintLabelLayoutEntity(
    formWidth: 800,
    formHeight: 108,
    quantityColumns: 1,
    labelWidth: labelWidth,
    labelHeight: 0,
    labelPrinter: printer,
    fields: fields,
  );
  return PrintLabelPreviewMetrics(layout);
}

BSFPrintLabelLayoutFieldEntity _rabbitField({
  double coordinateX = 0,
  double coordinateY = 0,
  double width = 1,
  double height = 1,
  double ratioBarCode = 0,
  bool drawLabelBelowBarcode = false,
  String fontType = '3',
  String previewValue = 'Texto',
  BSFPrintLabelFieldType fieldType = BSFPrintLabelFieldType.string,
  BSFPrintElementRotationType rotateType = BSFPrintElementRotationType.none,
}) => EntityFactory.makeBSFPrintLabelLayoutFieldEntity(
  coordinateX: coordinateX,
  coordinateY: coordinateY,
  width: width,
  height: height,
  dimensionType: BSFPrintLabelFieldDimensionType.scaleFactor,
  fontType: fontType,
  fontSize: 0,
  ratioBarCode: ratioBarCode,
  drawLabelBelowBarcode: drawLabelBelowBarcode,
  previewValue: previewValue,
  rotateType: rotateType,
  field: EntityFactory.makeBSFPrintLabelFieldDefinitionEntity(
    fieldType: fieldType,
  ),
);
