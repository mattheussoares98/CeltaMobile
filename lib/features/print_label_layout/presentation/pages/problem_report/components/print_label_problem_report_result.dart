import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PrintLabelProblemReportResult extends ConsumerWidget {
  final int layoutCode;

  const PrintLabelProblemReportResult({super.key, required this.layoutCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref
        .watch(printLabelProblemReportControllerProvider(layoutCode))
        .requireValue;
    final result = state.result!;

    return Center(
      child: Column(
        key: const Key('print-label-problem-report-result'),
        mainAxisSize: MainAxisSize.min,
        children: [
          PlatformIcon(
            materialIcon: Icons.check_circle_outline,
            cupertinoIcon: CupertinoIcons.checkmark_circle,
            size: Sizes.p64,
            color: context.theme.colorScheme.primary,
          ),
          gapH16,
          BaseText.titleLarge('Relatório enviado'.hardcoded),
          gapH8,
          BaseText.bodyMedium('ID: ${result.reportId}'.hardcoded),
          gapH8,
          PrimaryTextButton(text: 'Fechar'.hardcoded, onPressed: context.pop),
        ],
      ),
    );
  }
}
