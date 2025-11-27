import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file_plus/open_file_plus.dart';

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

    bool downloadedLastExecution =
        asyncValue.value?.executionResult.Executions.any(
          (e) => e.Attachments.any((e) => e.FileExtension == downloadType.name),
        ) ??
        false;

    void openExcelFile(bool showDialog) async {
      final controller = await ref.read(
        downloadStateControllerProvider(report.Code, downloadType).future,
      );

      if (controller?.xlsxFilePath != null && showDialog) {
        showAlertDialog(
          context: context,
          title: 'Planilha baixada'.hardcoded,
          content:
              'Planilha baixada em "${controller?.xlsxFilePath}"'.hardcoded,
          defaultActionText: 'Abrir arquivo'.hardcoded,
          cancelActionText: 'Ok'.hardcoded,
          onOkPressed: () {
            OpenFile.open(controller?.xlsxFilePath);
          },
        );
      } else if (controller?.xlsxFilePath != null) {
        OpenFile.open(controller?.xlsxFilePath);
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 6,
          child: PrimaryTextButton(
            color: downloadedLastExecution ? theme.disabledColor : null,
            text: downloadedLastExecution
                ? downloadType == DownloadType.pdf
                      ? 'PDF baixado'
                      : 'Planilha baixada'
                : downloadType == DownloadType.pdf
                ? 'Baixar PDF'.hardcoded
                : 'Baixar planilha'.hardcoded,
            isLoading: asyncValue.isLoading,
            icon: Icon(isIOS ? CupertinoIcons.cloud_download : Icons.download),
            onPressed: downloadedLastExecution
                ? null
                : () async {
                    await ref
                        .read(
                          downloadStateControllerProvider(
                            report.Code,
                            downloadType,
                          ).notifier,
                        )
                        .download(theme.platform, report.ReportModelName);

                    openExcelFile(true);
                  },
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
            } else if (asyncValue.value!.executionResult.Executions.isEmpty) {
              return const SizedBox.shrink();
            } else if (asyncValue
                .value!
                .executionResult
                .Executions
                .first
                .Attachments
                .isEmpty) {
              return const SizedBox.shrink();
            }

            final executions = asyncValue.value!.executionResult.Executions;
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
                openExcelFile(false);
              }
            }

            return InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p4),
                child: Row(
                  children: [
                    if (executions.first.ExecutionDate != null) ...[
                      gapW4,
                      Text(
                        'Visualizar'.hardcoded,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.primaryColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    gapW8,
                    Icon(
                      isIOS ? CupertinoIcons.eye : Icons.remove_red_eye,
                      color: theme.primaryColor,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
