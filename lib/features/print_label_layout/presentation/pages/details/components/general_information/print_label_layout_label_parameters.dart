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
    final capabilities = layout.capabilities;
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
              alignment: .spaceEvenly,
              runAlignment: .spaceEvenly,
              children: [
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-label-width'),
                  repeatInterval: const Duration(milliseconds: 5),
                  label: 'Largura'.hardcoded,
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
                  label: 'Altura'.hardcoded,
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
                  label: 'Mg direita'.hardcoded,
                  repeatInterval: const Duration(milliseconds: 25),
                  value: _formatValue(layout.labelRightMargin, unit),
                  currentValue: layout.labelRightMargin,
                  min: 0,
                  onValueChanged: (val) => controller.updateLabelRightMargin(
                    val.toDouble() - layout.labelRightMargin,
                  ),
                  onDecrease: () => controller.updateLabelRightMargin(-step),
                  onIncrease: () => controller.updateLabelRightMargin(step),
                ),
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-label-bottom-margin'),
                  label: 'Mg inferior'.hardcoded,
                  repeatInterval: const Duration(milliseconds: 25),
                  value: _formatValue(layout.labelBottomMargin, unit),
                  currentValue: layout.labelBottomMargin,
                  min: 0,
                  enabled: capabilities.canEditLabelBottomMargin,
                  onValueChanged: (val) => controller.updateLabelBottomMargin(
                    val.toDouble() - layout.labelBottomMargin,
                  ),
                  onDecrease: () => controller.updateLabelBottomMargin(-step),
                  onIncrease: () => controller.updateLabelBottomMargin(step),
                ),
              ],
            ),
            if (capabilities.supportedDirections.isNotEmpty) ...[
              gapH8,
              BaseText.caption('Direção da etiqueta'.hardcoded),
              gapH4,
              BaseSegmentedButtons<BSFPrintLabelDirectionType>(
                key: const Key('print-label-layout-direction'),
                items: capabilities.supportedDirections,
                selectedValue: layout.directionLabelType,
                itemLabelBuilder: _directionLabel,
                onChanged: capabilities.canEditDirection
                    ? controller.updateDirectionLabelType
                    : null,
              ),
            ],
            if (capabilities.showsProductPacking) ...[
              gapH8,
              BaseText.caption('Considerar embalagem do produto'.hardcoded),
              gapH4,
              BaseSegmentedButtons<BSFProductPackingSelectionType>(
                key: const Key('print-label-layout-product-packing'),
                items: BSFProductPackingSelectionType.values,
                selectedValue: layout.considerProductPacking,
                itemLabelBuilder: (item) => item.label,
                onChanged: (value) =>
                    controller.updateConsiderProductPacking(value),
              ),
            ],
            if (capabilities.showsQuantityPerProduct) ...[
              gapH8,
              BaseSwitch(
                key: const Key('print-label-layout-quantity-per-product'),
                title: 'Informar quantidade de impressão por produto'.hardcoded,
                value: layout.informPrintQuantityByProduct,
                onChanged: (value) =>
                    controller.updateInformPrintQuantityByProduct(value),
              ),
            ],
            if (capabilities.showsPrintBySoldQuantity) ...[
              gapH8,
              BaseSwitch(
                key: const Key('print-label-layout-print-by-sold-quantity'),
                title:
                    'Imprimir uma etiqueta para cada unidade vendida'.hardcoded,
                value: layout.printProductBySoldQuantity,
                onChanged: controller.updatePrintProductBySoldQuantity,
              ),
            ],
            if (capabilities.showsBalanceBehavior) ...[
              gapH8,
              BaseSwitch(
                key: const Key('print-label-layout-balance-behavior'),
                title:
                    'Somente produtos enviados para balanço e que permitem quantidade no balanço'
                        .hardcoded,
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

  String _directionLabel(BSFPrintLabelDirectionType direction) =>
      switch (direction) {
        BSFPrintLabelDirectionType.top => 'Superior'.hardcoded,
        BSFPrintLabelDirectionType.left => 'Esquerda'.hardcoded,
        BSFPrintLabelDirectionType.bottom => 'Inferior'.hardcoded,
        BSFPrintLabelDirectionType.right => 'Direita'.hardcoded,
      };
}
