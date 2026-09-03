import 'dart:math' as math;
import 'dart:typed_data';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/details/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrintLabelPreviewElement extends StatelessWidget {
  final BSFPrintLabelLayoutFieldEntity field;
  final BSFPrintLabelCoordinateUnit coordinateUnit;
  final PrintLabelPreviewMetrics previewMetrics;
  final double scaleX;
  final double scaleY;
  final bool isOutsideLabel;
  final bool isInsideFilledBox;

  const PrintLabelPreviewElement({
    super.key,
    required this.field,
    required this.coordinateUnit,
    required this.previewMetrics,
    required this.scaleX,
    required this.scaleY,
    required this.isOutsideLabel,
    required this.isInsideFilledBox,
  });

  static const _minimumSymbolSize = 24.0;
  static const _maximumSymbolSize = 160.0;
  static const _minimumBarcodeWidth = 48.0;
  static const _maximumBarcodeWidth = 240.0;

  @override
  Widget build(BuildContext context) {
    final width = _previewWidth;
    final height = _previewHeight;
    final element = SizedBox(
      width: width,
      height: height,
      child: _fieldContent(context, width: width, height: height),
    );

    return Transform.rotate(
      angle: _rotationAngle,
      alignment: Alignment.topLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: isOutsideLabel
              ? Border.all(color: context.theme.colorScheme.error)
              : null,
        ),
        child: element,
      ),
    );
  }

  Widget _fieldContent(
    BuildContext context, {
    required double? width,
    required double? height,
  }) {
    if (_isQrCode) return _qrCode(context);

    return switch (_fieldType) {
      BSFPrintLabelFieldType.barcode => _barcode(context),
      BSFPrintLabelFieldType.logo => _logo(context),
      BSFPrintLabelFieldType.boxOrLine => _boxOrLine(context),
      _ => _text(context, width: width, height: height),
    };
  }

  Widget _qrCode(BuildContext context) => FittedBox(
    alignment: Alignment.topLeft,
    child: PlatformIcon(
      materialIcon: Icons.qr_code_2,
      cupertinoIcon: CupertinoIcons.qrcode,
      color: context.theme.colorScheme.onSurface,
    ),
  );

  Widget _barcode(BuildContext context) {
    return Semantics(
      image: true,
      label: field.drawLabelBelowBarcode ? _previewText : null,
      child: CustomPaint(
        painter: PrintLabelBarcodePainter(
          color: context.theme.colorScheme.onSurface,
          value: _previewText,
          captionHeight: _fontSize,
          drawValue: field.drawLabelBelowBarcode,
        ),
      ),
    );
  }

  Widget _logo(BuildContext context) {
    final logo = field.previewImage?.isNotEmpty == true
        ? field.previewImage
        : field.field?.logo;

    if (logo != null && logo.isNotEmpty) {
      final bytes = logo is Uint8List ? logo : Uint8List.fromList(logo);
      return Image.memory(
        bytes,
        fit: BoxFit.fill,
        alignment: Alignment.topLeft,
        errorBuilder: (_, _, _) => _logoPlaceholder(context),
      );
    }

    return _logoPlaceholder(context);
  }

  Widget _logoPlaceholder(BuildContext context) => Semantics(
    image: true,
    label: 'Logotipo'.hardcoded,
    child: ColoredBox(
      color: context.theme.colorScheme.onSurface.withAlpha(48),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: PlatformIcon(
          materialIcon: Icons.image_outlined,
          cupertinoIcon: CupertinoIcons.photo,
          color: context.theme.colorScheme.onSurface,
        ),
      ),
    ),
  );

  Widget _boxOrLine(BuildContext context) {
    if (previewMetrics.isFilledBox(field)) {
      return ColoredBox(color: context.theme.colorScheme.onSurface);
    }

    final configuredThickness = field.ratioBarCode * math.min(scaleX, scaleY);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.theme.colorScheme.onSurface,
          width: configuredThickness > 0 ? configuredThickness : 1,
        ),
      ),
    );
  }

  Widget _text(
    BuildContext context, {
    required double? width,
    required double? height,
  }) {
    final reverseText = field.isReverseText || isInsideFilledBox;

    final foregroundColor = reverseText
        ? context.theme.colorScheme.surface
        : context.theme.colorScheme.onSurface;
    final backgroundColor = field.isReverseText
        ? context.theme.colorScheme.onSurface
        : null;

    final text = Text(
      _previewText,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.visible,
      textAlign: _textAlign,
      style: TextStyle(
        color: foregroundColor,
        fontFamily: previewMetrics.isRabbitOS214
            ? 'monospace'
            : field.fontType.isEmpty
            ? null
            : field.fontType,
        fontSize: _fontSize,
        height: previewMetrics.isRabbitOS214 ? 1 : null,
        fontWeight: field.isBold
            ? FontWeight.bold
            : previewMetrics.isRabbitOS214 && field.fontTypeNumber == 6
            ? FontWeight.w600
            : FontWeight.normal,
      ),
    );

    if (previewMetrics.isRabbitOS214 && width != null && height != null) {
      final fittedText = FittedBox(
        fit: BoxFit.fill,
        alignment: _alignment,
        child: text,
      );
      return backgroundColor == null
          ? fittedText
          : ColoredBox(color: backgroundColor, child: fittedText);
    }

    final alignedText = width == null
        ? text
        : Align(alignment: _alignment, child: text);

    return backgroundColor == null
        ? alignedText
        : ColoredBox(color: backgroundColor, child: alignedText);
  }

  double? get _previewWidth {
    if (_isQrCode) {
      return previewMetrics.qrCodeRenderedSize(field) * scaleX;
    }

    if (previewMetrics.isRabbitOS214 && _usesRabbitRenderedDimensions) {
      return previewMetrics.renderedWidth(field, text: _previewText) * scaleX;
    }

    if (_fieldType == BSFPrintLabelFieldType.logo && field.width > 0) {
      return field.width * scaleX;
    }

    if (_hasPhysicalDimensions && field.width > 0) {
      return field.width * scaleX;
    }

    return switch (_fieldType) {
      BSFPrintLabelFieldType.barcode when _isQrCode => _symbolSize,
      BSFPrintLabelFieldType.barcode =>
        field.width > 0
            ? field.width * scaleX
            : (_fontSize *
                      math.max(6, math.min(_previewText.length, 16) * 0.65))
                  .clamp(_minimumBarcodeWidth, _maximumBarcodeWidth),
      BSFPrintLabelFieldType.logo => _symbolSize,
      _ => null,
    };
  }

  double? get _previewHeight {
    if (_isQrCode) {
      return previewMetrics.qrCodeRenderedSize(field) * scaleY;
    }

    if (previewMetrics.isRabbitOS214 && _usesRabbitRenderedDimensions) {
      return previewMetrics.renderedHeight(field) * scaleY;
    }

    if (_fieldType == BSFPrintLabelFieldType.logo && field.height > 0) {
      return field.height * scaleY;
    }

    if (_hasPhysicalDimensions && field.height > 0) {
      return field.height * scaleY;
    }

    return switch (_fieldType) {
      BSFPrintLabelFieldType.barcode when _isQrCode => _symbolSize,
      BSFPrintLabelFieldType.barcode =>
        field.height > 0
            ? field.height * scaleY
            : (_fontSize * 3).clamp(_minimumSymbolSize, _maximumSymbolSize),
      BSFPrintLabelFieldType.logo => _symbolSize,
      _ => null,
    };
  }

  double get _symbolSize {
    final configuredScale = math.max(field.width.abs(), field.height.abs());
    return (_fontSize * math.max(2, configuredScale)).clamp(
      _minimumSymbolSize,
      _maximumSymbolSize,
    );
  }

  bool get _hasPhysicalDimensions =>
      field.dimensionType == BSFPrintLabelFieldDimensionType.centimeter ||
      field.dimensionType == BSFPrintLabelFieldDimensionType.printerDot;

  BSFPrintLabelFieldType get _fieldType =>
      field.field?.fieldType ?? BSFPrintLabelFieldType.string;

  bool get _isQrCode => field.isQrCode;

  bool get _isText => field.isTextField;

  bool get _usesRabbitRenderedDimensions =>
      _isText || field.isBarcode || field.isBoxOrLine;

  double get _fontSize {
    if (previewMetrics.isRabbitOS214) {
      if (_fieldType == BSFPrintLabelFieldType.barcode) {
        return previewMetrics.rabbitBarcodeCaptionFontSize(scaleY);
      }
      return previewMetrics.rabbitFontSize(field, scaleY);
    }

    if (field.fontSize <= 0) return 10;

    final scaledSize = coordinateUnit == BSFPrintLabelCoordinateUnit.centimeter
        ? field.fontSize * 2.54 / 72 * scaleY
        : field.fontSize * scaleY;

    return scaledSize.clamp(4, 72);
  }

  String get _previewText =>
      previewMetrics.visiblePreviewText(field, fallback: 'Campo'.hardcoded);

  Alignment get _alignment => switch (field.alignmentType) {
    BSFPrintElementAlignmentType.left => Alignment.topLeft,
    BSFPrintElementAlignmentType.middle => Alignment.topCenter,
    BSFPrintElementAlignmentType.right => Alignment.topRight,
  };

  TextAlign get _textAlign => switch (field.alignmentType) {
    BSFPrintElementAlignmentType.left => TextAlign.left,
    BSFPrintElementAlignmentType.middle => TextAlign.center,
    BSFPrintElementAlignmentType.right => TextAlign.right,
  };

  double get _rotationAngle => switch (field.rotateType) {
    BSFPrintElementRotationType.none => 0,
    BSFPrintElementRotationType.rotate90 => math.pi / 2,
    BSFPrintElementRotationType.rotate180 => math.pi,
    BSFPrintElementRotationType.rotate270 => math.pi * 3 / 2,
  };
}
