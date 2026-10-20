import 'dart:math' as math;

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/details/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class PrintLabelLayoutPreview extends StatelessWidget {
  final BSFPrintLabelLayoutEntity layout;
  final bool showPreviewMessage;
  final GlobalKey? canvasKey;

  const PrintLabelLayoutPreview({
    super.key,
    required this.layout,
    this.showPreviewMessage = true,
    this.canvasKey,
  });

  static const _maximumPreviewHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    final previewMetrics = PrintLabelPreviewMetrics(layout);
    final previewLabelWidth = previewMetrics.canvasWidth;
    final previewLabelHeight = previewMetrics.canvasHeight;
    final hasValidLabelSize =
        previewLabelWidth.isFinite &&
        previewLabelHeight.isFinite &&
        previewLabelWidth > 0 &&
        previewLabelHeight > 0;
    final isUndefinedPaginatedHeight =
        !layout.capabilities.isLabelHeightRequired &&
        previewLabelWidth.isFinite &&
        previewLabelWidth > 0 &&
        (!previewLabelHeight.isFinite || previewLabelHeight <= 0);
    final coordinateUnit =
        layout.coordinateUnit ?? BSFPrintLabelCoordinateUnit.centimeter;

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showPreviewMessage) ...[
          BaseRichText(
            texts: [
              BaseText.title(context.l10n.preview),
              BaseText.title(context.l10n.approximate, color: Colors.red),
            ],
          ),
          gapH4,
        ],
        gapH4,
        if (isUndefinedPaginatedHeight)
          BaseText.caption(
            context.l10n.addFieldsToDetermineThePreviewHeight,
            color: context.theme.colorScheme.error,
          )
        else if (!hasValidLabelSize)
          BaseText.caption(
            context.l10n.enterAValidWidthAndHeightToPreviewTheLabel,
            color: context.theme.colorScheme.error,
          )
        else
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) => _buildPreview(
                context,
                constraints,
                previewMetrics: previewMetrics,
                previewLabelWidth: previewLabelWidth,
                previewLabelHeight: previewLabelHeight,
                coordinateUnit: coordinateUnit,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPreview(
    BuildContext context,
    BoxConstraints constraints, {
    required PrintLabelPreviewMetrics previewMetrics,
    required double previewLabelWidth,
    required double previewLabelHeight,
    required BSFPrintLabelCoordinateUnit coordinateUnit,
  }) {
    final availableWidth = math.max(0.0, constraints.maxWidth);
    final aspectRatio = previewLabelWidth / previewLabelHeight;
    final canvasHeight = math.min(
      math.min(availableWidth / aspectRatio, _maximumPreviewHeight),
      constraints.maxHeight,
    );
    final previewScale = canvasHeight / previewLabelHeight;
    final drawableLabelWidth = previewMetrics.drawableCanvasWidth;
    final canvasWidth = drawableLabelWidth * previewScale;
    final isRabbitOS214 = previewMetrics.isRabbitOS214;
    final visibleFields = layout.fields.where((field) => field.isVisible);
    final fieldsInPaintOrder = visibleFields
        .where(previewMetrics.isFilledBox)
        .followedBy(
          visibleFields.where((field) => !previewMetrics.isFilledBox(field)),
        );

    return SizedBox(
      height: canvasHeight,
      child: Center(
        child: RepaintBoundary(
          key: canvasKey,
          child: SizedBox(
            key: const ValueKey('print-label-preview-canvas'),
            width: canvasWidth,
            height: canvasHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                border: Border.all(color: context.theme.colorScheme.outline),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: fieldsInPaintOrder.map((field) {
                  final scaleX = previewScale;
                  final scaleY = previewScale;

                  return Positioned(
                    left: previewMetrics.horizontalPosition(field) * scaleX,
                    top: previewMetrics.verticalPosition(field) * scaleY,
                    child: PrintLabelPreviewElement(
                      fallbackText: context.l10n.field,
                      field: field,
                      coordinateUnit: coordinateUnit,
                      previewMetrics: previewMetrics,
                      scaleX: scaleX,
                      scaleY: scaleY,
                      isOutsideLabel: _isOutsideLabel(
                        field,
                        previewMetrics: previewMetrics,
                        isRabbitOS214: isRabbitOS214,
                        drawableLabelWidth: drawableLabelWidth,
                        previewLabelWidth: previewLabelWidth,
                        previewLabelHeight: previewLabelHeight,
                      ),
                      isInsideFilledBox: previewMetrics.isInsideFilledBox(
                        field,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isOutsideLabel(
    BSFPrintLabelLayoutFieldEntity field, {
    required PrintLabelPreviewMetrics previewMetrics,
    required bool isRabbitOS214,
    required double drawableLabelWidth,
    required double previewLabelWidth,
    required double previewLabelHeight,
  }) {
    if (field.coordinateX < 0 || field.coordinateY < 0) return true;

    if (isRabbitOS214) {
      return previewMetrics.exceedsRabbitBounds(
        field,
        drawableWidth: drawableLabelWidth,
        previewHeight: previewLabelHeight,
      );
    }

    if (previewMetrics.usesNativeElementMetrics) {
      return previewMetrics.exceedsPreviewBounds(
        field,
        previewWidth: previewLabelWidth,
        previewHeight: previewLabelHeight,
      );
    }

    final hasPhysicalDimensions =
        field.dimensionType == BSFPrintLabelFieldDimensionType.centimeter ||
        field.dimensionType == BSFPrintLabelFieldDimensionType.printerDot;
    if (!hasPhysicalDimensions) {
      return field.coordinateX > previewLabelWidth ||
          field.coordinateY > previewLabelHeight;
    }

    return previewMetrics.exceedsPreviewBounds(
      field,
      previewWidth: previewLabelWidth,
      previewHeight: previewLabelHeight,
    );
  }
}
