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
            BaseText.title('Parâmetros do formulário ($unitLabel)'.hardcoded),
            gapH8,
            BaseText.caption('Tipo de formulário'.hardcoded),
            gapH4,
            BaseSegmentedButtons<BSFPrintLabelFormType>(
              key: const Key('print-label-layout-form-type'),
              items: BSFPrintLabelFormType.values,
              selectedValue: layout.formType,
              itemLabelBuilder: (item) => item.description,
              onChanged: capabilities.canEditFormType
                  ? (value) => controller.updateFormType(value)
                  : null,
            ),
            gapH8,
            Wrap(
              alignment: .spaceEvenly,
              runAlignment: .spaceEvenly,
              children: [
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-form-width'),
                  repeatInterval: const Duration(milliseconds: 25),
                  label: 'Largura'.hardcoded,
                  value: _formatValue(layout.formWidth, unit),
                  onDecrease: layout.formWidth > 0
                      ? () => controller.updateFormWidth(-step)
                      : null,
                  onIncrease: () => controller.updateFormWidth(step),
                ),
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-form-height'),
                  label: capabilities.isFormHeightRequired
                      ? 'Altura *'.hardcoded
                      : 'Altura'.hardcoded,
                  value: _formatValue(layout.formHeight, unit),
                  onDecrease:
                      capabilities.canEditFormHeight && layout.formHeight > 0
                      ? () => controller.updateFormHeight(-step)
                      : null,
                  onIncrease: capabilities.canEditFormHeight
                      ? () => controller.updateFormHeight(step)
                      : null,
                ),
              ],
            ),
            Wrap(
              alignment: .spaceEvenly,
              runAlignment: .spaceEvenly,
              children: [
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-form-top-margin'),
                  label: 'Mg superior'.hardcoded,
                  value: _formatValue(layout.formTopMargin, unit),
                  onDecrease: layout.formTopMargin > 0
                      ? () => controller.updateFormTopMargin(-step)
                      : null,
                  onIncrease: () => controller.updateFormTopMargin(step),
                ),
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-form-left-margin'),
                  label: 'Mg esquerda'.hardcoded,
                  value: _formatValue(layout.formLeftMargin, unit),
                  onDecrease: layout.formLeftMargin > 0
                      ? () => controller.updateFormLeftMargin(-step)
                      : null,
                  onIncrease: () => controller.updateFormLeftMargin(step),
                ),
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-quantity-columns'),
                  label: 'Colunas'.hardcoded,
                  value: layout.quantityColumns.toString(),
                  onDecrease:
                      capabilities.canEditQuantityColumns &&
                          layout.quantityColumns > 1
                      ? () => controller.updateQuantityColumns(-1)
                      : null,
                  onIncrease:
                      capabilities.canEditQuantityColumns &&
                          layout.quantityColumns < 99
                      ? () => controller.updateQuantityColumns(1)
                      : null,
                ),
              ],
            ),
            gapH8,
            BaseSwitch(
              key: const Key('print-label-layout-apply-form-size'),
              title: 'Aplicar configuração do tamanho do formulário'.hardcoded,
              value: layout.applyFormSizeConfiguration,
              onChanged: capabilities.canEditFormSizeConfiguration
                  ? (value) =>
                        controller.updateApplyFormSizeConfiguration(value)
                  : null,
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
