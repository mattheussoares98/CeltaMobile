import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  group('PrintLabelPreviewMetrics', () {
    test('should derive Rabbit canvas size from field extents', () {
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
          previewHeight: 100,
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

      expect(metrics.canvasWidth, closeTo(603.4, 0.001));
      expect(metrics.drawableCanvasWidth, closeTo(420, 0.001));
      expect(metrics.renderedWidth(box), 190);
      expect(metrics.renderedHeight(box), 150);
      expect(metrics.horizontalPosition(box), 210);
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

    test('should compensate Rabbit 270-degree rotated text position', () {
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
      final metrics = _metrics([date, barcode, plu], labelWidth: 840);

      expect(metrics.horizontalPosition(date), 0);
      expect(
        metrics.horizontalPosition(plu),
        plu.coordinateX + metrics.renderedHeight(plu),
      );
      expect(metrics.verticalPosition(date), metrics.verticalPosition(plu));
      expect(metrics.drawableCanvasWidth, closeTo(436.8, 0.001));
      expect(
        metrics.exceedsRabbitBounds(
          plu,
          drawableWidth: metrics.drawableCanvasWidth,
          previewHeight: metrics.canvasHeight,
        ),
        isFalse,
      );
    });
  });
}

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
    formHeight: 0,
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
