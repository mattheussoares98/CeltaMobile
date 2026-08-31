import 'dart:math' as math;

import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class PrintLabelPreviewMetrics {
  final BSFPrintLabelLayoutEntity layout;

  const PrintLabelPreviewMetrics(this.layout);

  static const _rabbitConfiguredWidthScale = 0.55;
  static const _rabbitTrailingMarginRatio = 0.12;
  static const _rabbitBarcodeCaptionHeight = 8.0;
  static const _rabbitCurrencyHorizontalCorrection = 12.0;
  static const _rabbitCurrencyVerticalCorrection = -4.0;

  bool get isRabbitOS214 =>
      layout.labelPrinter?.modelType == BSFLabelPrinterModelType.rabbitOS214;

  double get canvasWidth {
    if (!isRabbitOS214) {
      return layout.labelWidth > 0 ? layout.labelWidth : layout.formWidth;
    }

    if (layout.fields.isEmpty) return 0;

    final leadingMargin = layout.fields
        .map((field) => field.coordinateX)
        .where((coordinate) => coordinate > 0)
        .fold<double>(0, _smallestPositive);
    final contentRight = layout.fields.fold<double>(0, (value, field) {
      return math.max(
        value,
        field.coordinateX + horizontalCanvasFootprint(field),
      );
    });

    final trailingMargin = math.max(
      leadingMargin,
      contentRight * _rabbitTrailingMarginRatio,
    );
    final configuredWidth =
        (layout.labelWidth > 0 ? layout.labelWidth : layout.formWidth) *
        _rabbitConfiguredWidthScale;
    return math.max(configuredWidth, contentRight + trailingMargin);
  }

  double get canvasHeight {
    if (layout.labelHeight > 0) return layout.labelHeight;
    if (layout.formHeight > 0) return layout.formHeight;
    if (layout.fields.isEmpty) return 0;

    if (!isRabbitOS214) {
      final greatestCoordinateY = layout.fields.fold<double>(
        0,
        (value, field) => math.max(value, field.coordinateY),
      );
      return greatestCoordinateY + (canvasWidth * 0.1);
    }

    final leadingMargin = layout.fields
        .map((field) => field.coordinateY)
        .where((coordinate) => coordinate > 0)
        .fold<double>(0, _smallestPositive);
    final contentBottom = layout.fields.fold<double>(0, (value, field) {
      return math.max(value, field.coordinateY + renderedHeight(field));
    });

    return contentBottom + leadingMargin;
  }

  double renderedWidth(BSFPrintLabelLayoutFieldEntity field) {
    if (!isRabbitOS214) return field.width;
    if (_fieldType(field) == BSFPrintLabelFieldType.barcode) {
      return _rabbitBarcodeModuleCount(field) * math.max(1, field.ratioBarCode);
    }
    if (_fieldType(field) == BSFPrintLabelFieldType.boxOrLine) {
      return math.max(field.width, field.ratioBarCode);
    }
    if (!_isText(field)) return field.width;

    return rabbitGlyphWidth(field) *
        _horizontalMultiplier(field) *
        math.max(1, previewText(field).length);
  }

  double renderedHeight(BSFPrintLabelLayoutFieldEntity field) {
    if (!isRabbitOS214) return field.height;
    if (_fieldType(field) == BSFPrintLabelFieldType.barcode) {
      return field.height +
          (field.drawLabelBelowBarcode ? _rabbitBarcodeCaptionHeight : 0);
    }
    if (_fieldType(field) == BSFPrintLabelFieldType.boxOrLine) {
      return math.max(field.height, field.ratioBarCode);
    }
    if (!_isText(field)) return field.height;

    return rabbitGlyphHeight(field) * _verticalMultiplier(field);
  }

  double horizontalCanvasFootprint(BSFPrintLabelLayoutFieldEntity field) {
    if (!isRabbitOS214) return field.width;
    if (_fieldType(field) == BSFPrintLabelFieldType.boxOrLine) {
      return renderedWidth(field);
    }
    if (!_isText(field)) return field.width;

    // Text may intentionally overflow. One native glyph is sufficient to find
    // the configured label edge without expanding the canvas to fit the value.
    return rabbitGlyphWidth(field) * _horizontalMultiplier(field);
  }

  double rabbitFontSize(BSFPrintLabelLayoutFieldEntity field, double scaleY) =>
      renderedHeight(field) * scaleY;

  double rabbitBarcodeCaptionFontSize(double scaleY) =>
      _rabbitBarcodeCaptionHeight * scaleY;

  double horizontalPosition(BSFPrintLabelLayoutFieldEntity field) {
    final isCurrencyIndicator =
        isRabbitOS214 &&
        field.fontType == '1' &&
        previewText(field).trim() == r'R$';
    return field.coordinateX +
        (isCurrencyIndicator ? _rabbitCurrencyHorizontalCorrection : 0);
  }

  double verticalPosition(BSFPrintLabelLayoutFieldEntity field) {
    if (!isRabbitOS214) return field.coordinateY;

    final isCurrencyIndicator =
        field.fontType == '1' && previewText(field).trim() == r'R$';
    final currencyCorrection = isCurrencyIndicator
        ? _rabbitCurrencyVerticalCorrection
        : 0;
    return canvasHeight -
        field.coordinateY -
        renderedHeight(field) +
        currencyCorrection;
  }

  bool isFilledBox(BSFPrintLabelLayoutFieldEntity field) {
    if (!isRabbitOS214 ||
        _fieldType(field) != BSFPrintLabelFieldType.boxOrLine) {
      return false;
    }

    final smallestDimension = math.min(field.width, field.height);
    return smallestDimension > 0 && field.ratioBarCode * 2 >= smallestDimension;
  }

  bool isInsideFilledBox(BSFPrintLabelLayoutFieldEntity field) {
    if (!isRabbitOS214 ||
        _fieldType(field) == BSFPrintLabelFieldType.boxOrLine) {
      return false;
    }

    return layout.fields.where(isFilledBox).any((box) {
      return field.coordinateX >= box.coordinateX &&
          field.coordinateX < box.coordinateX + renderedWidth(box) &&
          field.coordinateY >= box.coordinateY &&
          field.coordinateY < box.coordinateY + renderedHeight(box);
    });
  }

  String previewText(BSFPrintLabelLayoutFieldEntity field) {
    if (field.previewValue != null) return field.previewValue!;

    final definition = field.fieldForDataBarcode ?? field.field;
    final value = definition?.content.isNotEmpty == true
        ? definition!.content
        : definition?.name ?? '';
    return '${field.prefix}$value';
  }

  double rabbitGlyphWidth(BSFPrintLabelLayoutFieldEntity field) =>
      switch (field.fontType) {
        '1' => 3,
        '2' => 5,
        '3' => 8,
        '4' => 10,
        '5' => 14,
        '6' => 11,
        '7' => 12,
        '8' => 14,
        '9' => math.max(1, field.width * 0.5),
        _ => 5,
      };

  double rabbitGlyphHeight(BSFPrintLabelLayoutFieldEntity field) =>
      switch (field.fontType) {
        '1' => 7,
        '2' => 12,
        '3' => 18,
        '4' => 24,
        '5' => 32,
        '6' => 48,
        '7' => 24,
        '8' => 32,
        '9' => math.max(1, field.width),
        _ => 12,
      };

  double _horizontalMultiplier(BSFPrintLabelLayoutFieldEntity field) =>
      field.fontType == '9' ? 1 : math.max(1, field.width);

  double _verticalMultiplier(BSFPrintLabelLayoutFieldEntity field) =>
      field.fontType == '9' ? 1 : math.max(1, field.height);

  double _rabbitBarcodeModuleCount(BSFPrintLabelLayoutFieldEntity field) =>
      switch (previewText(field).length) {
        13 => 95,
        8 => 67,
        final length => math.max(1, length * 11),
      };

  bool _isText(BSFPrintLabelLayoutFieldEntity field) {
    final type = _fieldType(field);
    return type != BSFPrintLabelFieldType.barcode &&
        type != BSFPrintLabelFieldType.logo &&
        type != BSFPrintLabelFieldType.boxOrLine;
  }

  BSFPrintLabelFieldType _fieldType(BSFPrintLabelLayoutFieldEntity field) =>
      field.field?.fieldType ?? BSFPrintLabelFieldType.string;

  double _smallestPositive(double current, double value) =>
      current == 0 ? value : math.min(current, value);
}
