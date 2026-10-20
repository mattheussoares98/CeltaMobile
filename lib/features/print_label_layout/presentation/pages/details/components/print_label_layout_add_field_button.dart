import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintLabelLayoutAddFieldButton extends ConsumerWidget {
  final int layoutCode;

  const PrintLabelLayoutAddFieldButton({super.key, required this.layoutCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPrinter = ref.watch(
      printLabelLayoutDetailsControllerProvider(
        layoutCode,
      ).select((state) => state.value?.labelPrinter),
    );

    if (layoutCode == 0 && selectedPrinter == null) {
      return PrimaryButton(
        text: context.l10n.selectThePrinter,
        icon: const PlatformIcon(
          cupertinoIcon: CupertinoIcons.add,
          materialIcon: Icons.add,
        ),
      );
    }

    final provider = printLabelFieldEditorOptionsControllerProvider(layoutCode);

    return AsyncValueWidget(
      value: ref.watch(provider),
      tryAgain: () => ref.invalidate(provider),
      data: (options) => PrimaryButton(
        text: context.l10n.addField,
        icon: const PlatformIcon(
          cupertinoIcon: CupertinoIcons.add,
          materialIcon: Icons.add,
        ),
        onPressed: options.fieldOptions.isEmpty
            ? null
            : () => showModalPage(
                PrintLabelLayoutAddFieldPage(
                  layoutCode: layoutCode,
                  fieldOptions: options.fieldOptions,
                  formats: options.formats,
                ),
                context,
              ),
      ),
    );
  }
}
