import 'package:celta_inventario/features/print_label_layout/presentation/localization/localization.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
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
            BaseText.title(context.l10n.formParametersWithUnit(unitLabel)),
            gapH8,
            BaseText.caption(context.l10n.formType),
            gapH4,
            BaseSegmentedButtons<BSFPrintLabelFormType>(
              key: const Key('print-label-layout-form-type'),
              items: BSFPrintLabelFormType.values,
              selectedValue: layout.formType,
              itemLabelBuilder: (item) => context.l10n.labelFormTypeName(item),
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
                  repeatInterval: const Duration(milliseconds: 5),
                  label: context.l10n.width,
                  value: _formatValue(layout.formWidth, unit),
                  currentValue: layout.formWidth,
                  min: 0,
                  onValueChanged: (val) => controller.updateFormWidth(
                    val.toDouble() - layout.formWidth,
                  ),
                  onDecrease: () => controller.updateFormWidth(-step),
                  onIncrease: () => controller.updateFormWidth(step),
                ),
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-form-height'),
                  repeatInterval: const Duration(milliseconds: 5),
                  label: capabilities.isFormHeightRequired
                      ? context.l10n.height2
                      : context.l10n.height,
                  value: _formatValue(layout.formHeight, unit),
                  currentValue: layout.formHeight,
                  min: 0,
                  enabled: capabilities.canEditFormHeight,
                  onValueChanged: (val) => controller.updateFormHeight(
                    val.toDouble() - layout.formHeight,
                  ),
                  onDecrease: () => controller.updateFormHeight(-step),
                  onIncrease: () => controller.updateFormHeight(step),
                ),
              ],
            ),
            Wrap(
              alignment: .spaceEvenly,
              runAlignment: .spaceEvenly,
              children: [
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-form-top-margin'),
                  label: context.l10n.topMargin,
                  value: _formatValue(layout.formTopMargin, unit),
                  currentValue: layout.formTopMargin,
                  min: 0,
                  onValueChanged: (val) => controller.updateFormTopMargin(
                    val.toDouble() - layout.formTopMargin,
                  ),
                  onDecrease: () => controller.updateFormTopMargin(-marginStep),
                  onIncrease: () => controller.updateFormTopMargin(marginStep),
                ),
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-form-left-margin'),
                  label: context.l10n.leftMargin,
                  value: _formatValue(layout.formLeftMargin, unit),
                  currentValue: layout.formLeftMargin,
                  min: 0,
                  onValueChanged: (val) => controller.updateFormLeftMargin(
                    val.toDouble() - layout.formLeftMargin,
                  ),
                  onDecrease: () =>
                      controller.updateFormLeftMargin(-marginStep),
                  onIncrease: () => controller.updateFormLeftMargin(marginStep),
                ),
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-quantity-columns'),
                  label: context.l10n.columns,
                  value: layout.quantityColumns.toString(),
                  currentValue: layout.quantityColumns,
                  min: 1,
                  max: 99,
                  enabled: capabilities.canEditQuantityColumns,
                  onValueChanged: (val) => controller.updateQuantityColumns(
                    val.toInt() - layout.quantityColumns,
                  ),
                  onDecrease: () => controller.updateQuantityColumns(-1),
                  onIncrease: () => controller.updateQuantityColumns(1),
                ),
              ],
            ),
            gapH8,
            BaseSwitch(
              key: const Key('print-label-layout-apply-form-size'),
              title: context.l10n.applyFormSizeSettings,
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
