import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintLabelLayoutAddFieldButton extends ConsumerWidget {
  final int layoutCode;

  const PrintLabelLayoutAddFieldButton({super.key, required this.layoutCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = printLabelFieldEditorOptionsControllerProvider(layoutCode);

    return AsyncValueWidget(
      value: ref.watch(provider),
      tryAgain: () => ref.invalidate(provider),
      data: (options) => PrimaryButton(
        text: 'Adicionar campo'.hardcoded,
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
                ),
                context,
              ),
      ),
    );
  }
}
