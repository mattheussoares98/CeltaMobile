import 'dart:math' as math;

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class PrintLabelLayoutPreview extends StatelessWidget {
  final BSFPrintLabelLayoutEntity layout;

  const PrintLabelLayoutPreview({super.key, required this.layout});

  static const _maximumPreviewHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BaseText.title('Pré-visualização'.hardcoded),
            gapH4,
            BaseText.caption(
              _coordinateUnit.description.hardcoded,
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
            gapH8,
            if (!_hasValidLabelSize)
              BaseText.caption(
                'Informe uma largura e altura válidas para visualizar a etiqueta.'
                    .hardcoded,
                color: context.theme.colorScheme.error,
              )
            else
              LayoutBuilder(builder: _previewBuilder),
          ],
        ),
      ),
    );
  }

  Widget _previewBuilder(BuildContext context, BoxConstraints constraints) {
    final availableWidth = math.max(0, constraints.maxWidth - Sizes.p48);
    final aspectRatio = _previewLabelWidth / _previewLabelHeight;
    final canvasHeight = math.min(
      availableWidth / aspectRatio,
      _maximumPreviewHeight,
    );
    final canvasWidth = canvasHeight * aspectRatio;

    return SizedBox(
      height: canvasHeight + Sizes.p48,
      child: Center(
        child: SizedBox(
          width: canvasWidth,
          height: canvasHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              border: Border.all(color: context.theme.colorScheme.outline),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: layout.fields.map((field) {
                final scaleX = canvasWidth / _previewLabelWidth;
                final scaleY = canvasHeight / _previewLabelHeight;

                return Positioned(
                  left: field.coordinateX * scaleX,
                  top: field.coordinateY * scaleY,
                  child: PrintLabelPreviewElement(
                    field: field,
                    coordinateUnit: _coordinateUnit,
                    scaleX: scaleX,
                    scaleY: scaleY,
                    isOutsideLabel: _isOutsideLabel(field),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  bool _isOutsideLabel(BSFPrintLabelLayoutFieldEntity field) {
    if (field.coordinateX < 0 || field.coordinateY < 0) return true;

    final hasPhysicalDimensions =
        field.dimensionType == BSFPrintLabelFieldDimensionType.centimeter ||
        field.dimensionType == BSFPrintLabelFieldDimensionType.printerDot;
    if (!hasPhysicalDimensions) {
      return field.coordinateX > _previewLabelWidth ||
          field.coordinateY > _previewLabelHeight;
    }

    return field.coordinateX + field.width > _previewLabelWidth ||
        field.coordinateY + field.height > _previewLabelHeight;
  }

  bool get _hasValidLabelSize =>
      _previewLabelWidth.isFinite &&
      _previewLabelHeight.isFinite &&
      _previewLabelWidth > 0 &&
      _previewLabelHeight > 0;

  double get _previewLabelWidth =>
      layout.labelWidth > 0 ? layout.labelWidth : layout.formWidth;

  double get _previewLabelHeight {
    if (layout.labelHeight > 0) return layout.labelHeight;
    if (layout.formHeight > 0) return layout.formHeight;
    if (layout.fields.isEmpty || _previewLabelWidth <= 0) return 0;

    final greatestCoordinateY = layout.fields.fold<double>(
      0,
      (value, field) => math.max(value, field.coordinateY),
    );
    return greatestCoordinateY + (_previewLabelWidth * 0.1);
  }

  BSFPrintLabelCoordinateUnit get _coordinateUnit =>
      layout.labelPrinter?.coordinateUnit ??
      BSFPrintLabelCoordinateUnit.centimeter;
}
