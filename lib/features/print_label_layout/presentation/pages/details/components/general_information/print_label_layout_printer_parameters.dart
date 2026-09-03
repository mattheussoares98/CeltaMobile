import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BaseText.title('Parâmetros da impressora'.hardcoded),
            gapH8,
            Wrap(
              alignment: .spaceBetween,
              runAlignment: .spaceBetween,
              children: [
                PrintLabelLayoutValueAdjuster(
                  label: 'Temperatura'.hardcoded,
                  value: layout.temperature.toString(),
                  onDecrease: layout.temperature > 0
                      ? () => controller.updateTemperature(-1)
                      : null,
                  onIncrease: () => controller.updateTemperature(1),
                ),
                PrintLabelLayoutValueAdjuster(
                  label: 'Velocidade'.hardcoded,
                  value: layout.printSpeed.toString(),
                  onDecrease: layout.printSpeed > 0
                      ? () => controller.updatePrintSpeed(-1)
                      : null,
                  onIncrease: () => controller.updatePrintSpeed(1),
                ),
                PrintLabelLayoutValueAdjuster(
                  repeatInterval: const Duration(milliseconds: 25),
                  label: 'Intervalo do pacote'.hardcoded,
                  value: layout.intervalPrintPackage.toString(),
                  onDecrease: layout.intervalPrintPackage > 0
                      ? () => controller.updateIntervalPrintPackage(-1)
                      : null,
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
