import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PrintLabelProblemReportFailure extends ConsumerWidget {
  final int layoutCode;

  const PrintLabelProblemReportFailure({super.key, required this.layoutCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = printLabelProblemReportControllerProvider(layoutCode);
    final state = ref.watch(provider).requireValue;
    final controller = ref.read(provider.notifier);
    final canRetrySubmission =
        state.physicalLabel != null && state.canvasPreview != null;

    return Center(
      child: Column(
        key: const Key('print-label-problem-report-failure'),
        mainAxisSize: MainAxisSize.min,
        children: [
          PlatformIcon(
            cupertinoIcon: CupertinoIcons.exclamationmark_circle,
            materialIcon: Icons.error_outline,
            size: Sizes.p48,
            color: context.theme.colorScheme.error,
          ),
          gapH8,
          BaseText.titleMedium(
            'Não foi possível concluir o relatório.'.hardcoded,
            textAlign: TextAlign.center,
          ),
          gapH16,
          PrimaryButton(
            key: const Key('retry-print-label-problem-report'),
            text: canRetrySubmission
                ? 'Tentar novamente'.hardcoded
                : 'Refazer capturas'.hardcoded,
            onPressed: canRetrySubmission
                ? controller.retry
                : controller.retakeImages,
          ),
        ],
      ),
    );
  }
}
