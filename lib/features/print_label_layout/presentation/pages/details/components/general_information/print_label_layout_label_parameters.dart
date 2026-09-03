import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
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
    final unit = layout.coordinateUnit;
    final step = unit == BSFPrintLabelCoordinateUnit.centimeter ? 0.1 : 1.0;
    final unitLabel = unit == BSFPrintLabelCoordinateUnit.centimeter
        ? 'cm'
        : 'pontos'.hardcoded;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BaseText.title('Parâmetros da etiqueta ($unitLabel)'.hardcoded),
            gapH8,
            Wrap(
              alignment: .spaceBetween,
              runAlignment: .spaceBetween,
              children: [
                PrintLabelLayoutValueAdjuster(
                  repeatInterval: const Duration(milliseconds: 25),
                  label: 'Largura'.hardcoded,
                  value: _formatValue(layout.labelWidth, unit),
                  onDecrease: layout.labelWidth > 0
                      ? () => controller.updateLabelWidth(-step)
                      : null,
                  onIncrease: () => controller.updateLabelWidth(step),
                ),
                PrintLabelLayoutValueAdjuster(
                  label: 'Margem direita'.hardcoded,
                  repeatInterval: const Duration(milliseconds: 25),
                  value: _formatValue(layout.labelRightMargin, unit),
                  onDecrease: layout.labelRightMargin > 0
                      ? () => controller.updateLabelRightMargin(-step)
                      : null,
                  onIncrease: () => controller.updateLabelRightMargin(step),
                ),
                PrintLabelLayoutValueAdjuster(
                  label: 'Margem inferior'.hardcoded,
                  repeatInterval: const Duration(milliseconds: 25),
                  value: _formatValue(layout.labelBottomMargin, unit),
                  onDecrease: layout.labelBottomMargin > 0
                      ? () => controller.updateLabelBottomMargin(-step)
                      : null,
                  onIncrease: () => controller.updateLabelBottomMargin(step),
                ),
              ],
            ),
            gapH8,
            BaseText.caption('Considerar embalagem do produto'.hardcoded),
            gapH4,
            BaseSegmentedButtons<BSFProductPackingSelectionType>(
              items: BSFProductPackingSelectionType.values,
              selectedValue: layout.considerProductPacking,
              itemLabelBuilder: (item) => item.label,
              onChanged: (value) =>
                  controller.updateConsiderProductPacking(value),
            ),
            gapH8,
            BaseSwitch(
              title: 'Informar quantidade de impressão por produto'.hardcoded,
              value: layout.informPrintQuantityByProduct,
              onChanged: (value) =>
                  controller.updateInformPrintQuantityByProduct(value),
            ),
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
}
