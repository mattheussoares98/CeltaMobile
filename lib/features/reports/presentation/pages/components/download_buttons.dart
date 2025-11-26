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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DefaultButton(DownloadType.pdf, report),
        gapH8,
        _DefaultButton(DownloadType.xlsx, report),
      ],
    );
  }
}

class _DefaultButton extends ConsumerWidget {
  final DownloadType downloadType;
  final ReportScheduleEntity report;
  const _DefaultButton(this.downloadType, this.report);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return PrimaryTextButton(
      text: downloadType == DownloadType.pdf ? 'Baixar PDF' : 'Baixar planilha',
      isLoading: ref.watch(
        downloadStateControllerProvider(
          report.Code,
          downloadType,
        ).select((s) => s.isLoading),
      ),
      icon: Icon(isIOS ? CupertinoIcons.cloud_download : Icons.download),
      onPressed: () {
        ref
            .read(
              downloadStateControllerProvider(
                report.Code,
                downloadType,
              ).notifier,
            )
            .download();
      },
    );
  }
}
