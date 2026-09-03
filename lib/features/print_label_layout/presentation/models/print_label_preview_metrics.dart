import 'dart:math' as math;

import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:intl/intl.dart';

class PrintLabelPreviewMetrics {
  final BSFPrintLabelLayoutEntity layout;

  const PrintLabelPreviewMetrics(this.layout);

  static const _rabbitConfiguredWidthScale = 0.55;
  static const _rabbitDrawableWidthScale = 0.52;
  static const _rabbitDrawableTrailingMarginRatio = 0.04;
  static const _rabbitBarcodeCaptionHeight = 8.0;
  static const _rabbitCurrencyHorizontalCorrection = 12.0;
  static const _rabbitCurrencyVerticalCorrection = -4.0;
  static const _rabbitFilledBoxPriceHorizontalCorrection = 10.0;
  static const _rabbitBarcodeRatioDivisor = 2.3;
  // Calibrates PPLA horizontal command values against the normalized preview
  // canvas while preserving the printer's configured proportions.
  static const _rabbitPplaBarcodeWidthScale = 0.30625;
  static const _centimetersPerInch = 2.54;
  static const _qrResolution = 96;
  static const _qrModuleDivisor = 29;
  static const _qrReferenceModuleCount = 45;

  bool get isRabbitOS214 => layout.isRabbitOS214;

  double get effectiveLabelWidth {
    if (layout.labelWidth > 0) return layout.labelWidth;
    if (layout.formWidth > 0) return layout.formWidth;
    return 0;
  }

  double get effectiveLabelHeight {
    if (layout.labelHeight > 0) return layout.labelHeight;
    if (layout.formHeight > 0) return layout.formHeight;
    return 0;
  }

  double get canvasWidth {
    if (!isRabbitOS214) return effectiveLabelWidth;
    return effectiveLabelWidth * _rabbitConfiguredWidthScale;
  }

  double get drawableCanvasWidth {
    if (!isRabbitOS214 || !layout.fields.any(_hasTwoFullHorizontalEdges)) {
      return canvasWidth;
    }

    var leadingMargin = 0.0;
    var contentRight = 0.0;
    for (final field in layout.fields) {
      if (field.coordinateX > 0) {
        leadingMargin = leadingMargin == 0
            ? field.coordinateX
            : math.min(leadingMargin, field.coordinateX);
      }
      final right = field.coordinateX + _rabbitDrawableFootprint(field);
      if (right > contentRight) contentRight = right;
    }

    final trailingMargin = math.max(
      leadingMargin,
      contentRight * _rabbitDrawableTrailingMarginRatio,
    );
    final calibratedWidth = math.max(
      effectiveLabelWidth * _rabbitDrawableWidthScale,
      contentRight + trailingMargin,
    );
    return math.min(canvasWidth, calibratedWidth);
  }

  double get canvasHeight {
    if (effectiveLabelHeight > 0) return effectiveLabelHeight;
    if (layout.fields.isEmpty) return 0;

    if (!isRabbitOS214) {
      var greatestCoordinateY = 0.0;
      for (final field in layout.fields) {
        if (field.coordinateY > greatestCoordinateY) {
          greatestCoordinateY = field.coordinateY;
        }
      }
      return greatestCoordinateY + (canvasWidth * 0.1);
    }

    var leadingMargin = 0.0;
    var contentBottom = 0.0;
    for (final field in layout.fields) {
      if (field.coordinateY > 0) {
        leadingMargin = leadingMargin == 0
            ? field.coordinateY
            : math.min(leadingMargin, field.coordinateY);
      }
      final bottom = field.coordinateY + renderedHeight(field);
      if (bottom > contentBottom) contentBottom = bottom;
    }

    return contentBottom + leadingMargin;
  }

  double renderedWidth(BSFPrintLabelLayoutFieldEntity field, {String? text}) {
    if (field.isQrCode) return qrCodeRenderedSize(field);
    if (!isRabbitOS214) return field.width;
    if (_fieldType(field) == BSFPrintLabelFieldType.barcode) {
      final baseModuleWidth = field.ratioBarCode > 0
          ? field.ratioBarCode / _rabbitBarcodeRatioDivisor
          : _rabbitPplaBarcodeWidthScale;
      final moduleWidth = math.max(0.5, field.width * baseModuleWidth);
      return _rabbitBarcodeModuleCount(field) * moduleWidth;
    }
    if (_fieldType(field) == BSFPrintLabelFieldType.boxOrLine) {
      return math.max(field.width, field.ratioBarCode);
    }
    if (!field.isTextField) return field.width;

    return rabbitGlyphWidth(field) *
        _horizontalMultiplier(field) *
        math.max(1, (text ?? previewText(field)).length);
  }

  double renderedHeight(BSFPrintLabelLayoutFieldEntity field) {
    if (field.isQrCode) return qrCodeRenderedSize(field);
    if (!isRabbitOS214) return field.height;
    if (_fieldType(field) == BSFPrintLabelFieldType.barcode) {
      return field.height +
          (field.drawLabelBelowBarcode ? _rabbitBarcodeCaptionHeight : 0);
    }
    if (_fieldType(field) == BSFPrintLabelFieldType.boxOrLine) {
      return math.max(field.height, field.ratioBarCode);
    }
    if (!field.isTextField) return field.height;

    return rabbitGlyphHeight(field) * _verticalMultiplier(field);
  }

  double qrCodeRenderedSize(BSFPrintLabelLayoutFieldEntity field) {
    final configuredSize = _roundToEven(field.height);
    if (configuredSize <= 0) return 0;

    final pixels = _roundToEven(
      configuredSize * _qrResolution / _centimetersPerInch,
    );
    final pixelsPerModule = pixels ~/ _qrModuleDivisor;
    final renderedPixels = (_qrReferenceModuleCount * pixelsPerModule)
        .toDouble();

    return field.dimensionType == BSFPrintLabelFieldDimensionType.centimeter
        ? renderedPixels * _centimetersPerInch / _qrResolution
        : renderedPixels;
  }

  int _roundToEven(double value) {
    final lower = value.floor();
    final fraction = value - lower;
    if (fraction < 0.5) return lower;
    if (fraction > 0.5) return lower + 1;
    return lower.isEven ? lower : lower + 1;
  }

  bool exceedsRabbitBounds(
    BSFPrintLabelLayoutFieldEntity field, {
    required double drawableWidth,
    required double previewHeight,
  }) {
    final width = renderedWidth(field, text: visiblePreviewText(field));
    final height = renderedHeight(field);
    final left = horizontalPosition(field);
    final bottom = verticalPosition(field);

    if (field.rotateType == BSFPrintElementRotationType.rotate270) {
      return left + height > drawableWidth ||
          bottom - width < 0 ||
          bottom > previewHeight;
    }

    return left + width > drawableWidth ||
        bottom < 0 ||
        bottom + height > previewHeight;
  }

  double _rabbitDrawableFootprint(BSFPrintLabelLayoutFieldEntity field) {
    if (_fieldType(field) == BSFPrintLabelFieldType.boxOrLine) {
      return math.max(field.width, field.ratioBarCode);
    }
    if (_fieldType(field) == BSFPrintLabelFieldType.barcode) {
      return renderedWidth(field);
    }
    if (!field.isTextField) return field.width;

    return rabbitGlyphWidth(field) * _horizontalMultiplier(field);
  }

  double rabbitFontSize(BSFPrintLabelLayoutFieldEntity field, double scaleY) =>
      renderedHeight(field) * scaleY;

  // TODO: Test the fontSize property in canvas metrics.

  double rabbitBarcodeCaptionFontSize(double scaleY) =>
      _rabbitBarcodeCaptionHeight * scaleY;

  double horizontalPosition(BSFPrintLabelLayoutFieldEntity field) {
    final isPriceInsideFilledBox =
        isRabbitOS214 &&
        field.fieldType == BSFPrintLabelFieldType.float &&
        field.fontType == '4' &&
        isInsideFilledBox(field);
    if (isPriceInsideFilledBox) {
      return field.coordinateX + _rabbitFilledBoxPriceHorizontalCorrection;
    }

    final isCurrencyIndicator =
        isRabbitOS214 &&
        field.fontType == '1' &&
        previewText(field).trim() == r'R$';
    if (isCurrencyIndicator) {
      return field.coordinateX + _rabbitCurrencyHorizontalCorrection;
    }

    if (isRabbitOS214 &&
        field.rotateType == BSFPrintElementRotationType.rotate270) {
      if (field.coordinateX > drawableCanvasWidth / 2) {
        return field.coordinateX + renderedHeight(field);
      }
      return math.max(0, field.coordinateX - (renderedHeight(field) / 2));
    }

    return field.coordinateX;
  }

  double verticalPosition(BSFPrintLabelLayoutFieldEntity field) {
    if (!isRabbitOS214) return field.coordinateY;

    if (field.rotateType == BSFPrintElementRotationType.rotate270) {
      return canvasHeight - field.coordinateY - (renderedHeight(field) / 4);
    }

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
    return smallestDimension > 0 &&
        field.ratioBarCode * 2 >= (smallestDimension - 1.0);
  }

  bool _hasTwoFullHorizontalEdges(BSFPrintLabelLayoutFieldEntity field) =>
      field.ratioBarCode > 0 && field.height >= field.ratioBarCode * 2;

  bool isInsideFilledBox(BSFPrintLabelLayoutFieldEntity field) {
    if (!isRabbitOS214 ||
        _fieldType(field) == BSFPrintLabelFieldType.boxOrLine) {
      return false;
    }

    for (final box in layout.fields) {
      if (box.isVisible &&
          isFilledBox(box) &&
          field.coordinateX >= box.coordinateX &&
          field.coordinateX < box.coordinateX + renderedWidth(box) &&
          field.coordinateY >= box.coordinateY &&
          field.coordinateY < box.coordinateY + renderedHeight(box)) {
        return true;
      }
    }
    return false;
  }

  String previewText(BSFPrintLabelLayoutFieldEntity field) {
    if (field.previewValue != null) return _formatPreviewValue(field);

    final definition = field.fieldForDataBarcode ?? field.field;
    final value = definition?.content.isNotEmpty == true
        ? definition!.content
        : definition?.name ?? '';
    return '${field.prefix}$value';
  }

  String visiblePreviewText(
    BSFPrintLabelLayoutFieldEntity field, {
    String fallback = '',
  }) {
    final definition = field.fieldForDataBarcode ?? field.field;
    final hasPreviewValue = field.previewValue != null;
    final value =
        (hasPreviewValue ? _formatPreviewValue(field) : null) ??
        (definition?.content.isNotEmpty == true
            ? definition!.content
            : definition?.name ?? fallback);
    if (!_usesTextCharacterOptions(field)) {
      return hasPreviewValue ? value : '${field.prefix}$value';
    }

    final start = (field.positionStartCharacter - 1).clamp(0, value.length);
    final end = field.maxCharacterSize > 0
        ? (start + field.maxCharacterSize).clamp(start, value.length)
        : value.length;
    final visibleValue = value.substring(start, end);
    return hasPreviewValue ? visibleValue : '${field.prefix}$visibleValue';
  }

  String _formatPreviewValue(BSFPrintLabelLayoutFieldEntity field) {
    final value = field.previewValue!;
    if (field.fieldType == BSFPrintLabelFieldType.float) {
      return _formatFloatPreviewValue(field, value);
    }
    if (field.fieldType != BSFPrintLabelFieldType.dateTime) return value;

    final dateTime = DateTime.now();
    final pattern = field.format?.dateTimePattern;
    if (pattern == null) return value;
    return DateFormat(pattern).format(dateTime);
  }

  String _formatFloatPreviewValue(
    BSFPrintLabelLayoutFieldEntity field,
    String value,
  ) {
    final prefix = field.prefix.isNotEmpty && value.startsWith(field.prefix)
        ? field.prefix
        : '';
    final numericText = value.substring(prefix.length).trim();
    final normalizedText = numericText.contains(',')
        ? numericText.replaceAll('.', '').replaceAll(',', '.')
        : numericText;
    if (double.tryParse(normalizedText) == null) return value;

    final parts = normalizedText.split('.');
    final integerPart = parts.first;
    final decimalPlaces = field.quantityDecimalPlaces;
    if (decimalPlaces == 0) return value;

    final fraction = parts.length > 1 ? parts[1] : '';
    final paddedFraction = fraction.padRight(decimalPlaces, '0');
    return '$prefix$integerPart,${paddedFraction.substring(0, decimalPlaces)}';
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

  bool _usesTextCharacterOptions(BSFPrintLabelLayoutFieldEntity field) =>
      field.usesTextCharacterOptions;

  BSFPrintLabelFieldType _fieldType(BSFPrintLabelLayoutFieldEntity field) =>
      field.field?.fieldType ?? BSFPrintLabelFieldType.string;
}
