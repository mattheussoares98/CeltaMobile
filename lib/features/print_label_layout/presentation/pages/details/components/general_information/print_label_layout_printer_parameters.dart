import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintLabelLayoutPrinterParameters extends ConsumerWidget {
  final BSFPrintLabelLayoutEntity layout;

  const PrintLabelLayoutPrinterParameters({super.key, required this.layout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(
      printLabelLayoutDetailsControllerProvider(layout.code).notifier,
    );
    final capabilities = layout.capabilities;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BaseText.title(context.l10n.printerParameters),
            gapH8,
            Wrap(
              alignment: .spaceEvenly,
              runAlignment: .spaceEvenly,
              runSpacing: Sizes.p8,
              spacing: Sizes.p8,
              children: [
                SizedBox(
                  width: 100,
                  child: BaseDropDown<String>(
                    key: const Key('print-label-layout-temperature'),
                    label: context.l10n.temperature,
                    showLabelAtTopLeft: true,
                    selectedItem:
                        capabilities.supportedTemperatures.contains(
                          layout.temperature.toString(),
                        )
                        ? layout.temperature.toString()
                        : null,
                    items: capabilities.supportedTemperatures
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: BaseText(value),
                          ),
                        )
                        .toList(),
                    onChanged: capabilities.canEditTemperature
                        ? (value) =>
                              controller.updateTemperature(int.parse(value))
                        : null,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: BaseDropDown<String>(
                    key: const Key('print-label-layout-print-speed'),
                    label: context.l10n.speed,
                    showLabelAtTopLeft: true,
                    selectedItem:
                        capabilities.supportedPrintSpeeds.contains(
                          layout.printSpeed.toString(),
                        )
                        ? layout.printSpeed.toString()
                        : null,
                    items: capabilities.supportedPrintSpeeds
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: BaseText(value),
                          ),
                        )
                        .toList(),
                    onChanged: capabilities.canEditPrintSpeed
                        ? (value) =>
                              controller.updatePrintSpeed(int.parse(value))
                        : null,
                  ),
                ),
                PrintLabelLayoutValueAdjuster(
                  key: const Key('print-label-layout-package-interval'),
                  repeatInterval: const Duration(milliseconds: 25),
                  label: context.l10n.packetInterval,
                  value: layout.intervalPrintPackage.toString(),
                  currentValue: layout.intervalPrintPackage,
                  min: 0,
                  enabled: capabilities.canEditPackageInterval,
                  onValueChanged: (val) =>
                      controller.updateIntervalPrintPackage(
                        val.toInt() - layout.intervalPrintPackage,
                      ),
                  onDecrease: () => controller.updateIntervalPrintPackage(-1),
                  onIncrease: () => controller.updateIntervalPrintPackage(1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
