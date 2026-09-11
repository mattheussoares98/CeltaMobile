import 'dart:math' as math;

import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:intl/intl.dart';

class PrintLabelPreviewMetrics {
  final BSFPrintLabelLayoutEntity layout;

  const PrintLabelPreviewMetrics(this.layout);

  static const _rabbitConfiguredWidthScale = 0.55;
  static const _rabbitDrawableWidthScale = 0.52;
  static const _rabbitMultiColumnDrawableWidthScale = 0.92;
  static const _rabbitDrawableTrailingMarginRatio = 0.04;
  static const _rabbitBarcodeCaptionHeight = 8.0;
  static const _rabbitCurrencyHorizontalCorrection = 12.0;
  static const _rabbitCurrencyVerticalCorrection = -4.0;
  static const _rabbitFilledBoxPriceHorizontalCorrection = 10.0;
  static const _rabbitBarcodeRatioDivisor = 2.3;
  // Calibrates PPLA horizontal command values against the normalized preview
  // canvas while preserving the printer's configured proportions.
  static const _rabbitPplaBarcodeWidthScale = 0.30625;
  static const _os214PlusHorizontalOriginCorrection = 20.0;
  static const _os214PlusBarcodeVerticalCorrection = 5.0;
  static const _centimetersPerInch = 2.54;
  static const _qrResolution = 96;
  static const _qrModuleDivisor = 29;
  static const _qrReferenceModuleCount = 45;

  bool get isRabbitOS214 => layout.isRabbitOS214;

  bool get isOS214Plus =>
      layout.labelPrinter?.modelType == BSFLabelPrinterModelType.os214Plus;

  bool get isZebraGC420t =>
      layout.labelPrinter?.modelType == BSFLabelPrinterModelType.zebraGC420t;

  bool get usesNativePplaMetrics => isRabbitOS214 || isOS214Plus;

  bool get usesNativeElementMetrics => usesNativePplaMetrics || isZebraGC420t;

  bool get _usesRabbitMultiColumnMargins =>
      isRabbitOS214 && layout.quantityColumns > 1;

  double get effectiveLabelWidth {
    if (isZebraGC420t && layout.formWidth > 0) return layout.formWidth;
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
    if (_usesRabbitMultiColumnMargins) {
      return effectiveLabelWidth +
          layout.formLeftMargin +
          layout.labelRightMargin;
    }
    return effectiveLabelWidth * _rabbitConfiguredWidthScale;
  }

  double get drawableCanvasWidth {
    if (!isRabbitOS214) return canvasWidth;
    if (_usesRabbitMultiColumnMargins) {
      return effectiveLabelWidth * _rabbitMultiColumnDrawableWidthScale +
          layout.formLeftMargin +
          layout.labelRightMargin;
    }
    if (!layout.fields.any(_hasTwoFullHorizontalEdges)) {
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
    final contentHeight = _contentCanvasHeight;
    if (!_usesRabbitMultiColumnMargins) return contentHeight;
    return contentHeight + layout.formTopMargin + layout.labelBottomMargin;
  }

  double get _contentCanvasHeight {
    if (effectiveLabelHeight > 0) return effectiveLabelHeight;
    if (layout.fields.isEmpty) return 0;

    if (!usesNativePplaMetrics) {
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
    if (isZebraGC420t) {
      if (_fieldType(field) == BSFPrintLabelFieldType.barcode) {
        return _rabbitBarcodeModuleCount(field) * math.max(1, field.width);
      }
      if (!field.isTextField) return field.width;
      return zebraGlyphWidth(field) *
          math.max(1, field.width) *
          math.max(1, (text ?? previewText(field)).trimRight().length);
    }
    if (!usesNativePplaMetrics) return field.width;
    if (isOS214Plus) {
      if (_fieldType(field) == BSFPrintLabelFieldType.barcode) {
        return _pplaBarcodeModuleCount(field) * math.max(1, field.width);
      }
      if (!field.isTextField) return field.width;
      return _os214PlusGlyphWidth(field) *
          math.max(1, field.width) *
          math.max(1, (text ?? previewText(field)).length);
    }
    if (_fieldType(field) == BSFPrintLabelFieldType.barcode) {
      final baseModuleWidth = layout.quantityColumns > 1
          ? _rabbitConfiguredWidthScale
          : field.ratioBarCode > 0
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
    if (isZebraGC420t) {
      if (_fieldType(field) == BSFPrintLabelFieldType.barcode) {
        return field.height +
            (field.drawLabelBelowBarcode ? zebraGlyphHeight(field) : 0);
      }
      if (!field.isTextField) return field.height;
      return zebraGlyphHeight(field) * math.max(1, field.height);
    }
    if (!usesNativePplaMetrics) return field.height;
    if (isOS214Plus) {
      if (_fieldType(field) == BSFPrintLabelFieldType.barcode) {
        return field.height +
            (field.drawLabelBelowBarcode ? _os214PlusGlyphHeight(field) : 0);
      }
      if (!field.isTextField) return field.height;
      return _os214PlusGlyphHeight(field) * math.max(1, field.height);
    }
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
  }) => exceedsPreviewBounds(
    field,
    previewWidth: drawableWidth,
    previewHeight: previewHeight,
  );

  bool exceedsPreviewBounds(
    BSFPrintLabelLayoutFieldEntity field, {
    required double previewWidth,
    required double previewHeight,
  }) {
    final width = renderedWidth(field, text: visiblePreviewText(field));
    final height = renderedHeight(field);
    final left = horizontalPosition(field);
    final top = verticalPosition(field);

    return switch (field.rotateType) {
      BSFPrintElementRotationType.none =>
        left < 0 ||
            top < 0 ||
            left + width > previewWidth ||
            top + height > previewHeight,
      BSFPrintElementRotationType.rotate90 =>
        left - height < 0 ||
            top < 0 ||
            left > previewWidth ||
            top + width > previewHeight,
      BSFPrintElementRotationType.rotate180 =>
        left - width < 0 ||
            top - height < 0 ||
            left > previewWidth ||
            top > previewHeight,
      BSFPrintElementRotationType.rotate270 =>
        left < 0 ||
            top - width < 0 ||
            left + height > previewWidth ||
            top > previewHeight,
    };
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

  double os214PlusFontSize(
    BSFPrintLabelLayoutFieldEntity field,
    double scaleY,
  ) => _os214PlusGlyphHeight(field) * scaleY;

  double rabbitBarcodeCaptionFontSize(double scaleY) =>
      _rabbitBarcodeCaptionHeight * scaleY;

  double zebraFontSize(BSFPrintLabelLayoutFieldEntity field, double scaleY) =>
      zebraGlyphHeight(field) * scaleY;

  double? zebraLogoWidth(BSFPrintLabelLayoutFieldEntity field) {
    final width = _bitmapDimension(field.previewImage, 18);
    return width == null ? null : width * math.max(0, field.width);
  }

  double? zebraLogoHeight(BSFPrintLabelLayoutFieldEntity field) {
    final height = _bitmapDimension(field.previewImage, 22);
    return height == null ? null : height * math.max(0, field.height);
  }

  double horizontalPosition(BSFPrintLabelLayoutFieldEntity field) {
    final margin = _usesRabbitMultiColumnMargins ? layout.formLeftMargin : 0.0;
    if (isOS214Plus) {
      return math.max(
        0,
        field.coordinateX - _os214PlusHorizontalOriginCorrection,
      );
    }

    final isPriceInsideFilledBox =
        isRabbitOS214 &&
        field.fieldType == BSFPrintLabelFieldType.float &&
        field.fontType == '4' &&
        isInsideFilledBox(field);
    if (isPriceInsideFilledBox) {
      return margin +
          field.coordinateX +
          _rabbitFilledBoxPriceHorizontalCorrection;
    }

    final isCurrencyIndicator =
        isRabbitOS214 &&
        field.fontType == '1' &&
        previewText(field).trim() == r'R$';
    if (isCurrencyIndicator) {
      return margin + field.coordinateX + _rabbitCurrencyHorizontalCorrection;
    }

    if (isRabbitOS214 &&
        field.rotateType == BSFPrintElementRotationType.rotate270) {
      if (field.coordinateX > drawableCanvasWidth / 2) {
        return margin + field.coordinateX + renderedHeight(field);
      }
      return margin +
          math.max(0, field.coordinateX - (renderedHeight(field) / 2));
    }

    return margin + field.coordinateX;
  }

  double verticalPosition(BSFPrintLabelLayoutFieldEntity field) {
    if (!usesNativePplaMetrics) return field.coordinateY;

    if (isOS214Plus) {
      final barcodeCorrection = field.isBarcode
          ? _os214PlusBarcodeVerticalCorrection
          : 0;
      return canvasHeight -
          field.coordinateY -
          renderedHeight(field) +
          barcodeCorrection;
    }

    if (field.rotateType == BSFPrintElementRotationType.rotate270) {
      return _rabbitPositioningHeight -
          field.coordinateY -
          (renderedHeight(field) / 4) +
          _rabbitTopMargin;
    }

    final isCurrencyIndicator =
        field.fontType == '1' && previewText(field).trim() == r'R$';
    final currencyCorrection = isCurrencyIndicator
        ? _rabbitCurrencyVerticalCorrection
        : 0;
    return _rabbitPositioningHeight -
        field.coordinateY -
        renderedHeight(field) +
        currencyCorrection +
        _rabbitTopMargin;
  }

  double get _rabbitPositioningHeight =>
      _usesRabbitMultiColumnMargins ? _contentCanvasHeight : canvasHeight;

  double get _rabbitTopMargin =>
      _usesRabbitMultiColumnMargins ? layout.formTopMargin : 0;

  bool isFilledBox(BSFPrintLabelLayoutFieldEntity field) {
    if (!usesNativePplaMetrics ||
        _fieldType(field) != BSFPrintLabelFieldType.boxOrLine) {
      return false;
    }

    final smallestDimension = math.min(field.width, field.height);
    return smallestDimension > 0 &&
        field.ratioBarCode * 2 >= (smallestDimension - 1.0);
  }

  bool _hasTwoFullHorizontalEdges(BSFPrintLabelLayoutFieldEntity field) =>
      (_fieldType(field) == BSFPrintLabelFieldType.boxOrLine ||
          (_fieldType(field) == BSFPrintLabelFieldType.barcode &&
              layout.quantityColumns == 1)) &&
      field.ratioBarCode > 0 &&
      field.height >= field.ratioBarCode * 2;

  bool isInsideFilledBox(BSFPrintLabelLayoutFieldEntity field) {
    if (!usesNativePplaMetrics ||
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

  double zebraGlyphWidth(BSFPrintLabelLayoutFieldEntity field) =>
      switch (field.fontType) {
        '1' => 8,
        '2' => 10,
        '3' => 12,
        '4' => 14,
        '5' => 32,
        '6' => 14,
        '7' => 21,
        _ => 8,
      };

  double zebraGlyphHeight(BSFPrintLabelLayoutFieldEntity field) =>
      switch (field.fontType) {
        '1' => 12,
        '2' => 16,
        '3' => 20,
        '4' => 24,
        '5' => 48,
        '6' => 19,
        '7' => 27,
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

  double _os214PlusGlyphWidth(BSFPrintLabelLayoutFieldEntity field) {
    if (field.fontType == '9') {
      return math.max(1, field.fontSize * 0.75);
    }
    return switch (field.fontType) {
      '1' => 6.25,
      '2' => 12.5,
      '3' => 17.5,
      '4' => 22.5,
      '5' => 37.5,
      '6' => 21.25,
      '7' => 25,
      '8' => 35,
      ':' => 35,
      _ => 10,
    };
  }

  double _os214PlusGlyphHeight(BSFPrintLabelLayoutFieldEntity field) {
    if (field.fontType == '9') {
      return math.max(1, field.fontSize * 1.25);
    }
    return switch (field.fontType) {
      '1' => 8.75,
      '2' => 15,
      '3' => 25,
      '4' => 32.5,
      '5' => 57.5,
      '6' => 30,
      '7' => 37.5,
      '8' => 52.5,
      ':' => 52.5,
      _ => 15,
    };
  }

  double _pplaBarcodeModuleCount(BSFPrintLabelLayoutFieldEntity field) {
    final value = previewText(field);
    if (_hasValidEanChecksum(value, 13)) return 117;
    if (_hasValidEanChecksum(value, 8)) return 81;

    final dataSymbols = int.tryParse(value) != null && value.length.isEven
        ? value.length / 2
        : value.length.toDouble();
    return 11 * (dataSymbols + 3) + 13 + 20;
  }

  bool _hasValidEanChecksum(String value, int length) {
    if (value.length != length || int.tryParse(value) == null) return false;

    var sum = 0;
    for (var index = 0; index < length - 1; index++) {
      final digit = int.parse(value[index]);
      sum += digit * ((length - index).isEven ? 3 : 1);
    }
    return (10 - (sum % 10)) % 10 == int.parse(value[length - 1]);
  }

  int? _bitmapDimension(List<int>? bytes, int offset) {
    if (bytes == null || bytes.length < offset + 4) return null;
    if (bytes[0] != 0x42 || bytes[1] != 0x4D) return null;

    final value =
        bytes[offset] |
        (bytes[offset + 1] << 8) |
        (bytes[offset + 2] << 16) |
        (bytes[offset + 3] << 24);
    return value.abs();
  }

  bool _usesTextCharacterOptions(BSFPrintLabelLayoutFieldEntity field) =>
      field.usesTextCharacterOptions;

  BSFPrintLabelFieldType _fieldType(BSFPrintLabelLayoutFieldEntity field) =>
      field.field?.fieldType ?? BSFPrintLabelFieldType.string;
}
