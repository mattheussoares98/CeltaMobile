import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintLabelLayoutFormParameters extends ConsumerWidget {
  final BSFPrintLabelLayoutEntity layout;

  const PrintLabelLayoutFormParameters({super.key, required this.layout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(
      printLabelLayoutDetailsControllerProvider(layout.code).notifier,
    );
    final unit = layout.labelPrinter?.coordinateUnit;
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
            BaseText.title('Parâmetros do formulário ($unitLabel)'.hardcoded),
            gapH8,
            BaseText.caption('Tipo de formulário'.hardcoded),
            gapH4,
            BaseSegmentedButtons<BSFPrintLabelFormType>(
              items: BSFPrintLabelFormType.values,
              selectedValue: layout.formType,
              itemLabelBuilder: (item) => item.description,
              onChanged: (value) => controller.updateFormType(value),
            ),
            gapH8,
            Wrap(
              alignment: .spaceBetween,
              children: [
                PrintLabelLayoutValueAdjuster(
                  repeatInterval: const Duration(milliseconds: 25),
                  label: 'Largura'.hardcoded,
                  value: _formatValue(layout.formWidth, unit),
                  onDecrease: layout.formWidth > 0
                      ? () => controller.updateFormWidth(-step)
                      : null,
                  onIncrease: () => controller.updateFormWidth(step),
                ),
                PrintLabelLayoutValueAdjuster(
                  label: 'Mg superior'.hardcoded,
                  value: _formatValue(layout.formTopMargin, unit),
                  onDecrease: layout.formTopMargin > 0
                      ? () => controller.updateFormTopMargin(-step)
                      : null,
                  onIncrease: () => controller.updateFormTopMargin(step),
                ),
                PrintLabelLayoutValueAdjuster(
                  label: 'Mg esquerda'.hardcoded,
                  value: _formatValue(layout.formLeftMargin, unit),
                  onDecrease: layout.formLeftMargin > 0
                      ? () => controller.updateFormLeftMargin(-step)
                      : null,
                  onIncrease: () => controller.updateFormLeftMargin(step),
                ),
              ],
            ),
            gapH8,
            BaseSwitch(
              title: 'Aplicar configuração do tamanho do formulário'.hardcoded,
              value: layout.applyFormSizeConfiguration,
              onChanged: (value) =>
                  controller.updateApplyFormSizeConfiguration(value),
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
