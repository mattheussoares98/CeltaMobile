import 'dart:math' as math;

import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:intl/intl.dart';

class PrintLabelPreviewMetrics {
  final BSFPrintLabelLayoutEntity layout;

  const PrintLabelPreviewMetrics(this.layout);

  static const _rabbitConfiguredWidthScale = 0.55;
  static const _rabbitDrawableWidthScale = 0.52;
  static const _rabbitTrailingMarginRatio = 0.12;
  static const _rabbitDrawableTrailingMarginRatio = 0.04;
  static const _rabbitBarcodeCaptionHeight = 8.0;
  static const _rabbitCurrencyHorizontalCorrection = 12.0;
  static const _rabbitCurrencyVerticalCorrection = -4.0;
  static const _rabbitBarcodeRatioDivisor = 2.3;
  // Calibrates PPLA horizontal command values against the normalized preview
  // canvas while preserving the printer's configured proportions.
  static const _rabbitPplaBarcodeWidthScale = 0.30625;
  static const _rabbitPplaBoxCanvasExpansionScale = 1.85;

  bool get isRabbitOS214 => layout.isRabbitOS214;

  double get canvasWidth {
    if (!isRabbitOS214) {
      return layout.labelWidth > 0 ? layout.labelWidth : layout.formWidth;
    }

    if (layout.fields.isEmpty) return 0;

    var leadingMargin = 0.0;
    var contentRight = 0.0;
    for (final field in layout.fields) {
      if (field.coordinateX > 0) {
        leadingMargin = leadingMargin == 0
            ? field.coordinateX
            : math.min(leadingMargin, field.coordinateX);
      }
      final right = field.coordinateX + horizontalCanvasFootprint(field);
      if (right > contentRight) contentRight = right;
    }

    final trailingMargin = math.max(
      leadingMargin,
      contentRight * _rabbitTrailingMarginRatio,
    );
    final configuredWidth =
        (layout.labelWidth > 0 ? layout.labelWidth : layout.formWidth) *
        _rabbitConfiguredWidthScale;
    return math.max(configuredWidth, contentRight + trailingMargin);
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
      final footprint = _fieldType(field) == BSFPrintLabelFieldType.boxOrLine
          ? math.max(field.width, field.ratioBarCode)
          : horizontalCanvasFootprint(field);
      final right = field.coordinateX + footprint;
      if (right > contentRight) contentRight = right;
    }

    final trailingMargin = math.max(
      leadingMargin,
      contentRight * _rabbitDrawableTrailingMarginRatio,
    );
    final configuredWidth =
        (layout.labelWidth > 0 ? layout.labelWidth : layout.formWidth) *
        _rabbitDrawableWidthScale;
    return math.max(configuredWidth, contentRight + trailingMargin);
  }

  double get canvasHeight {
    if (layout.labelHeight > 0) return layout.labelHeight;
    if (layout.formHeight > 0) return layout.formHeight;
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

  double horizontalCanvasFootprint(BSFPrintLabelLayoutFieldEntity field) {
    if (!isRabbitOS214) return field.width;
    if (_fieldType(field) == BSFPrintLabelFieldType.boxOrLine) {
      final configuredWidth = math.max(field.width, field.ratioBarCode);
      return configuredWidth + _rabbitBoxCanvasExpansion(field);
    }
    if (_fieldType(field) == BSFPrintLabelFieldType.barcode) {
      return renderedWidth(field);
    }
    if (!field.isTextField) return field.width;

    // Text may intentionally overflow. One native glyph is sufficient to find
    // the configured label edge without expanding the canvas to fit the value.
    return rabbitGlyphWidth(field) * _horizontalMultiplier(field);
  }

  double rabbitFontSize(BSFPrintLabelLayoutFieldEntity field, double scaleY) =>
      renderedHeight(field) * scaleY;

  // TODO: Test the fontSize property in canvas metrics.

  double rabbitBarcodeCaptionFontSize(double scaleY) =>
      _rabbitBarcodeCaptionHeight * scaleY;

  double horizontalPosition(BSFPrintLabelLayoutFieldEntity field) {
    // TODO: Verify whether the canvas preview should apply field alignment.
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

  double _rabbitBoxCanvasExpansion(BSFPrintLabelLayoutFieldEntity field) {
    return _hasTwoFullHorizontalEdges(field)
        ? field.ratioBarCode * _rabbitPplaBoxCanvasExpansionScale
        : 0;
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
    if (field.fieldType != BSFPrintLabelFieldType.dateTime) return value;

    final dateTime = DateTime.now();
    final pattern = field.format?.dateTimePattern;
    if (pattern == null) return value;
    return DateFormat(pattern).format(dateTime);
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
