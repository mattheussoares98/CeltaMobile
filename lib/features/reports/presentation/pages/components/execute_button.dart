import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class ExecuteButton extends ConsumerWidget {
  final ReportScheduleEntity report;
  const ExecuteButton({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Row(
      children: [
        PrimaryButton(
          text: 'Executar'.hardcoded,
          isLoading: ref.watch(
            executeScheduleControllerProvider.select((s) => s.isLoading),
          ),
          onPressed: () async {
            bool? value = await showAlertDialog(
              context: context,
              title: 'Enviar por e-mail?',
              defaultActionText: 'Sim'.hardcoded,
              cancelActionText: 'Não'.hardcoded,
            );
            ref
                .read(executeScheduleControllerProvider.notifier)
                .execute(
                  sendEmailOnExecution: value == true,
                  reportScheduleCode: report.Code,
                );
          },
        ),
        if (report.LastExecutionDate != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Última execução'),
                Text(
                  DateFormat(
                    'dd/MM/yyyy HH:mm',
                  ).format(report.LastExecutionDate!),
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
