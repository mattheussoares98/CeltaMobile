import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class DownloadButtons extends ConsumerWidget {
  final ReportScheduleEntity report;
  const DownloadButtons({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final scheduleAsync = ref.watch(
      schedulesStateControllerProvider(report.Code),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryTextButton(
          text: 'Baixar PDF',
          isLoading: scheduleAsync.isLoading,
          icon: Icon(isIOS ? CupertinoIcons.cloud_download : Icons.download),
          onPressed: () {
            ref
                .read(schedulesStateControllerProvider(report.Code).notifier)
                .download(downloadPdf: true, downloadXlsx: false);
          },
        ),
        gapH8,
        PrimaryTextButton(
          text: 'Baixar planilha',
          isLoading: scheduleAsync.isLoading,
          icon: Icon(isIOS ? CupertinoIcons.cloud_download : Icons.download),
          onPressed: () {
            ref
                .read(schedulesStateControllerProvider(report.Code).notifier)
                .download(downloadPdf: false, downloadXlsx: true);
          },
        ),
      ],
    );
  }
}
