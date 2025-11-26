import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../routing/routing.dart';
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

    final asyncValue = ref.watch(
      downloadStateControllerProvider(report.Code, downloadType),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 6,
          child: PrimaryTextButton(
            text: downloadType == DownloadType.pdf
                ? 'Baixar PDF'
                : 'Baixar planilha',
            isLoading: asyncValue.isLoading,
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
          ),
        ),
        if (asyncValue.hasError) ...[
          gapW8,
          Expanded(
            flex: 6,
            child: Text(
              asyncValue.hasError ? asyncValue.error.toString() : '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.red,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ] else if (asyncValue.value != null &&
            downloadType == DownloadType.pdf) ...[
          //TODO should treat if the value in asyncValue is from pdf
          Row(
            children: [
              gapW8,
              IconButton(
                onPressed: () {
                  context.pushNamed(
                    Routes.pdfViewer.name,
                    extra: <String, dynamic>{
                      'bytes': asyncValue.value!.Executions.first.Attachments
                          .firstWhere((e) => e.FileExtension == 'pdf')
                          .AttachmentBase64,
                      'fileName': report.ReportModelName,
                    },
                  );
                }, //TODO organize better
                icon: Icon(
                  isIOS ? CupertinoIcons.eye : Icons.remove_red_eye,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
