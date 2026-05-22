import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/reports/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/reports/presentation/pages/components/buttons/buttons.dart';

class DefaultButton extends ConsumerWidget {
  final DownloadType downloadType;
  final ReportScheduleEntity report;
  const DefaultButton(this.downloadType, this.report, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isXlsx = downloadType == DownloadType.xlsx;
    final requestFolderToDownload =
        (theme.platform == TargetPlatform.windows ||
            theme.platform == TargetPlatform.macOS) &&
        (!kIsWeb);

    final hasAttachment = ref.watch(
      downloadStateControllerProvider(report.Code, downloadType).select(
        (s) =>
            s.value?.executionResult.Executions.any(
              (e) => e.Attachments.any(
                (x) => x.FileExtension == downloadType.name,
              ),
            ) ==
            true,
      ),
    );

    Uint8List? extractBytes() {
      return ref.read(
        downloadStateControllerProvider(report.Code, downloadType).select(
          (s) => s.value?.executionResult.Executions
              .firstWhereOrNull((e) => e.Attachments.isNotEmpty)
              ?.Attachments
              .firstWhereOrNull((e) => e.FileExtension == downloadType.name)
              ?.AttachmentBase64,
        ),
      );
    }

    void onTap() async {
      final bytes = extractBytes();

      if (bytes == null) {
        await ref
            .read(
              downloadStateControllerProvider(
                report.Code,
                downloadType,
              ).notifier,
            )
            .download(theme.platform, report.ReportModelName);
      }

      if (isXlsx) {
        final filePath = ref.read(
          downloadStateControllerProvider(
            report.Code,
            downloadType,
          ).select((s) => s.value?.xlsxFilePath),
        );
        if (filePath != null) {
          showAlertDialog(
            context: context,
            title: 'Planilha baixada'.hardcoded,
            content: 'Planilha baixada em "$filePath"'.hardcoded,
          );
        }
      }
    }

    final downloadedLastExecution = ref.watch(
      downloadStateControllerProvider(report.Code, downloadType).select(
        (s) =>
            s.value?.executionResult.Executions.any(
              (e) => e.Attachments.any(
                (e) => e.FileExtension == downloadType.name,
              ),
            ) ??
            false,
      ),
    );

    final isLoading = ref.watch(
      downloadStateControllerProvider(
        report.Code,
        downloadType,
      ).select((s) => s.isLoading),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: downloadedLastExecution
              ? isXlsx
                    ? 3
                    : 2
              : 3,
          child: PrimaryTextButton(
            color: downloadedLastExecution ? theme.disabledColor : null,
            textAlign: TextAlign.start,
            text: hasAttachment
                ? (isXlsx
                      ? 'Planilha baixada'.hardcoded
                      : 'PDF baixado'.hardcoded)
                : (isXlsx
                      ? 'Baixar planilha'.hardcoded
                      : 'Baixar PDF'.hardcoded),
            isLoading: isLoading,
            icon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.cloud_download,
              materialIcon: Icons.download,
            ),
            onPressed: hasAttachment ? null : onTap,
          ),
        ),

        Consumer(
          builder: (_, ref, _) {
            final error = ref.watch(
              downloadStateControllerProvider(
                report.Code,
                downloadType,
              ).select((s) => s.error),
            );

            if (error == null) return const SizedBox.shrink();

            return Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(bottom: Sizes.p8),
                child: Text(
                  error.toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            );
          },
        ),
        const Spacer(),
        Consumer(
          builder: (_, ref, _) {
            final Uint8List? fileBytes = extractBytes();

            if (!hasAttachment || fileBytes == null || kIsWeb) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isXlsx && !requestFolderToDownload)
                  ShareButton(fileBytes: fileBytes, report: report)
                else if (isXlsx && requestFolderToDownload)
                  VisualizeFilePathButton(this)
                else
                  VisualizePdfButton(
                    bytes: fileBytes,
                    modelName: report.ReportModelName,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
