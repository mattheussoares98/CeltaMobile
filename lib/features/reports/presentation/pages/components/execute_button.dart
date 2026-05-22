import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/reports/presentation/controllers/controllers.dart';

class ExecuteButton extends ConsumerWidget {
  final ReportScheduleEntity report;
  const ExecuteButton({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    ref.listen(executeScheduleControllerProvider(report.Code), (p, n) {
      n.showAlertDialogOnError(context);
      n.doOnSuccess(p, () {
        showAlertDialog(
          context: context,
          title: 'Atenção!'.hardcoded,
          content:
              'O relatório está sendo gerado novamente.\n\nAlguns relatórios demoram para serem gerados. Por isso, aguarde alguns instantes e consulte os relatórios novamente para verificar se a data da última geração foi alterada'
                  .hardcoded,
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
                Text('Última geração'.hardcoded),
                Text(
                  DateFormat(
                    'dd/MM/yyyy HH:mm',
                  ).format(report.LastExecutionDate!),
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
          ),

        Flexible(
          child: Consumer(
            builder: (_, ref, _) {
              return PrimaryButton(
                text: 'Gerar'.hardcoded,
                isLoading: ref.watch(
                  executeScheduleControllerProvider(
                    report.Code,
                  ).select((s) => s.isLoading),
                ),
                onPressed: () async {
                  bool? value = await showAlertDialog(
                    context: context,
                    title: 'Enviar por e-mail?'.hardcoded,
                    defaultActionText: 'Sim'.hardcoded,
                    cancelActionText: 'Não'.hardcoded,
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
