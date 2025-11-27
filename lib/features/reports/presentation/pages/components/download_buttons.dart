import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
    if (report.LastExecutionContainsData != true) {
      return const SizedBox.shrink();
    }

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
            onPressed: () => ref
                .read(
                  downloadStateControllerProvider(
                    report.Code,
                    downloadType,
                  ).notifier,
                )
                .download(),
          ),
        ),
        if (asyncValue.hasError) ...[
          gapW8,
          Expanded(
            flex: 6,
            child: Text(
              asyncValue.error.toString(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.red,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
        Builder(
          builder: (context) {
            if (asyncValue.value == null) {
              return const SizedBox.shrink();
            } else if (asyncValue.value!.Executions.isEmpty) {
              return const SizedBox.shrink();
            } else if (asyncValue.value!.Executions.first.Attachments.isEmpty) {
              return const SizedBox.shrink();
            }

            final executions = asyncValue.value!.Executions;
            final attachments = executions.first.Attachments;
            final pdfBytes = attachments
                .firstWhereOrNull((e) => e.FileExtension == downloadType.name)
                ?.AttachmentBase64;

            void onTap() {
              if (downloadType == DownloadType.pdf) {
                context.pushNamed(
                  Routes.pdfViewer.name,
                  extra: <String, dynamic>{
                    'bytes': pdfBytes,
                    'fileName': report.ReportModelName,
                  },
                );
              } else {
                //TODO share
              }
            }

            return InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  if (executions.first.ExecutionDate != null) ...[
                    gapW4,
                    Text(
                      DateFormat(
                        'dd/MM/yyyy HH:mm',
                      ).format(executions.first.ExecutionDate!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                  gapW8,
                  IconButton(
                    onPressed: onTap,
                    icon: Icon(
                      downloadType == DownloadType.pdf
                          ? (!isIOS ? CupertinoIcons.eye : Icons.remove_red_eye)
                          : (!isIOS ? CupertinoIcons.share : Icons.share),
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
