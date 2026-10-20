import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/reports/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExecuteButton extends ConsumerWidget {
  final ReportScheduleEntity report;
  const ExecuteButton({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(executeScheduleControllerProvider(report.Code), (p, n) {
      n.showAlertDialogOnError(context);
      n.doOnSuccess(p, () {
        showAlertDialog(
          context: context,
          title: context.l10n.attention,
          content:
              context.l10n.theReportIsBeingGeneratedAgainSomeReportsTakeLonger,
        );
      });
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (report.LastExecutionDate != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.lastGenerated),
                Text(
                  report.LastExecutionDate!.formatDate(
                    DateFormatType.ddMMyyyyHHmm,
                  ),
                  style: context.theme.textTheme.titleSmall,
                ),
              ],
            ),
          ),

        Flexible(
          child: Consumer(
            builder: (_, ref, _) {
              return PrimaryButton(
                text: context.l10n.generate,
                isLoading: ref.watch(
                  executeScheduleControllerProvider(
                    report.Code,
                  ).select((s) => s.isLoading),
                ),
                onPressed: () async {
                  bool? value = await showAlertDialog(
                    context: context,
                    title: context.l10n.sendByEmail,
                    defaultActionText: context.l10n.yes,
                    cancelActionText: context.l10n.no,
                  );
                  ref
                      .read(
                        executeScheduleControllerProvider(report.Code).notifier,
                      )
                      .execute(value == true);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
