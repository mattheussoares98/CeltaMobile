import 'package:celta_inventario/features/print_label_layout/presentation/localization/localization.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintLabelLayoutLabelParameters extends ConsumerWidget {
  final BSFPrintLabelLayoutEntity layout;

  const PrintLabelLayoutLabelParameters({super.key, required this.layout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(
      printLabelLayoutDetailsControllerProvider(layout.code).notifier,
    );
    final capabilities = layout.capabilities;
    final unit = layout.coordinateUnit;
    final step = unit == BSFPrintLabelCoordinateUnit.centimeter ? 0.1 : 1.0;
    const marginStep = 0.1;
    final unitLabel = unit == BSFPrintLabelCoordinateUnit.centimeter
        ? 'cm'
        : context.l10n.dots;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BaseText.title(context.l10n.labelParametersWithUnit(unitLabel)),
            gapH8,
            Wrap(
              alignment: .spaceEvenly,
              runAlignment: .spaceEvenly,
              children: [
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-label-width'),
                  repeatInterval: const Duration(milliseconds: 5),
                  label: context.l10n.width,
                  value: _formatValue(layout.labelWidth, unit),
                  currentValue: layout.labelWidth,
                  min: 0,
                  onValueChanged: (val) => controller.updateLabelWidth(
                    val.toDouble() - layout.labelWidth,
                  ),
                  onDecrease: () => controller.updateLabelWidth(-step),
                  onIncrease: () => controller.updateLabelWidth(step),
                ),
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-label-height'),
                  label: context.l10n.height,
                  repeatInterval: const Duration(milliseconds: 5),
                  value: _formatValue(layout.labelHeight, unit),
                  currentValue: layout.labelHeight,
                  min: 0,
                  enabled: capabilities.canEditLabelHeight,
                  onValueChanged: (val) => controller.updateLabelHeight(
                    val.toDouble() - layout.labelHeight,
                  ),
                  onDecrease: () => controller.updateLabelHeight(-step),
                  onIncrease: () => controller.updateLabelHeight(step),
                ),
              ],
            ),
            Wrap(
              alignment: .spaceEvenly,
              runAlignment: .spaceEvenly,
              children: [
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-label-right-margin'),
                  label: context.l10n.rightMargin,
                  repeatInterval: const Duration(milliseconds: 25),
                  value: _formatValue(layout.labelRightMargin, unit),
                  currentValue: layout.labelRightMargin,
                  min: 0,
                  onValueChanged: (val) => controller.updateLabelRightMargin(
                    val.toDouble() - layout.labelRightMargin,
                  ),
                  onDecrease: () =>
                      controller.updateLabelRightMargin(-marginStep),
                  onIncrease: () =>
                      controller.updateLabelRightMargin(marginStep),
                ),
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-label-bottom-margin'),
                  label: context.l10n.bottomMargin,
                  repeatInterval: const Duration(milliseconds: 25),
                  value: _formatValue(layout.labelBottomMargin, unit),
                  currentValue: layout.labelBottomMargin,
                  min: 0,
                  enabled: capabilities.canEditLabelBottomMargin,
                  onValueChanged: (val) => controller.updateLabelBottomMargin(
                    val.toDouble() - layout.labelBottomMargin,
                  ),
                  onDecrease: () =>
                      controller.updateLabelBottomMargin(-marginStep),
                  onIncrease: () =>
                      controller.updateLabelBottomMargin(marginStep),
                ),
              ],
            ),
            if (capabilities.supportedDirections.isNotEmpty) ...[
              gapH8,
              BaseText.caption(context.l10n.labelDirection),
              gapH4,
              BaseSegmentedButtons<BSFPrintLabelDirectionType>(
                key: const Key('print-label-layout-direction'),
                items: capabilities.supportedDirections,
                selectedValue: layout.directionLabelType,
                itemLabelBuilder: (direction) =>
                    _directionLabel(context, direction),
                onChanged: capabilities.canEditDirection
                    ? controller.updateDirectionLabelType
                    : null,
              ),
            ],
            if (capabilities.showsProductPacking) ...[
              gapH8,
              BaseText.caption(context.l10n.considerProductPackaging),
              gapH4,
              BaseSegmentedButtons<BSFProductPackingSelectionType>(
                key: const Key('print-label-layout-product-packing'),
                items: BSFProductPackingSelectionType.values,
                selectedValue: layout.considerProductPacking,
                itemLabelBuilder: (item) =>
                    context.l10n.productPackingSelectionName(item),
                onChanged: (value) =>
                    controller.updateConsiderProductPacking(value),
              ),
            ],
            if (capabilities.showsQuantityPerProduct) ...[
              gapH8,
              BaseSwitch(
                key: const Key('print-label-layout-quantity-per-product'),
                title: context.l10n.enterPrintQuantityPerProduct,
                value: layout.informPrintQuantityByProduct,
                onChanged: (value) =>
                    controller.updateInformPrintQuantityByProduct(value),
              ),
            ],
            if (capabilities.showsPrintBySoldQuantity) ...[
              gapH8,
              BaseSwitch(
                key: const Key('print-label-layout-print-by-sold-quantity'),
                title: context.l10n.printOneLabelForEachUnitSold,
                value: layout.printProductBySoldQuantity,
                onChanged: controller.updatePrintProductBySoldQuantity,
              ),
            ],
            if (capabilities.showsBalanceBehavior) ...[
              gapH8,
              BaseSwitch(
                key: const Key('print-label-layout-balance-behavior'),
                title: context
                    .l10n
                    .onlyProductsSentToInventoryCountingThatAllowACounted,
                value: layout.goesForBalanceAndQuantityInBalance,
                onChanged: controller.updateGoesForBalanceAndQuantityInBalance,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatValue(double value, BSFPrintLabelCoordinateUnit? unit) {
    if (unit == BSFPrintLabelCoordinateUnit.centimeter) {
      return value.toStringAsFixed(1);
    }
    return value.truncateToDouble() == value
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
  }

  String _directionLabel(
    BuildContext context,
    BSFPrintLabelDirectionType direction,
  ) => switch (direction) {
    BSFPrintLabelDirectionType.top => context.l10n.top,
    BSFPrintLabelDirectionType.left => context.l10n.left,
    BSFPrintLabelDirectionType.bottom => context.l10n.bottom,
    BSFPrintLabelDirectionType.right => context.l10n.right,
  };
}
