import 'dart:math' as math;

import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class PrintLabelPreviewMetrics {
  final BSFPrintLabelLayoutEntity layout;

  const PrintLabelPreviewMetrics(this.layout);

  static const _rabbitTrailingMarginRatio = 0.12;

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
    return contentRight + trailingMargin;
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

  double verticalPosition(BSFPrintLabelLayoutFieldEntity field) {
    if (!isRabbitOS214) return field.coordinateY;

    return canvasHeight - field.coordinateY - renderedHeight(field);
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
        '1' => 4,
        '2' => 5,
        '3' => 8,
        '4' => 10,
        '5' => 14,
        '6' => 20,
        '7' => 12,
        '8' => 14,
        '9' => math.max(1, field.width * 0.5),
        _ => 5,
      };

  double rabbitGlyphHeight(BSFPrintLabelLayoutFieldEntity field) =>
      switch (field.fontType) {
        '1' => 8,
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
