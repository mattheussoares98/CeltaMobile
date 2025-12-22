import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'buttons.dart';

class DefaultButton extends ConsumerWidget {
  final DownloadType downloadType;
  final ReportScheduleEntity report;
  const DefaultButton(this.downloadType, this.report, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final isXlsx = downloadType == DownloadType.xlsx;
    final isMobilePlatform =
        theme.platform != TargetPlatform.macOS &&
        theme.platform != TargetPlatform.windows &&
        !kIsWeb;

    final asyncValue = ref.watch(
      downloadStateControllerProvider(report.Code, downloadType),
    );

    final hasAttachment =
        asyncValue.value?.executionResult.Executions.any(
          (e) => e.Attachments.any((x) => x.FileExtension == downloadType.name),
        ) ==
        true;

    Uint8List? extractBytes(AsyncValue<DownloadExecutionEntity?> asyncValue) {
      return asyncValue.value?.executionResult.Executions
          .firstWhereOrNull((e) => e.Attachments.isNotEmpty)
          ?.Attachments
          .firstWhereOrNull((e) => e.FileExtension == downloadType.name)
          ?.AttachmentBase64;
    }

    void onTap() async {
      //TODO test this feature in all platforms

      final bytes = extractBytes(asyncValue);

      if (bytes == null) {
        if (!isMobilePlatform && isXlsx) {
          await showAlertDialog(
            context: context,
            title: 'Atenção'.hardcoded,
            content: 'Selecione a pasta que deseja salvar o arquivo'.hardcoded,
          );
        }
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

    final Uint8List? fileBytes = extractBytes(asyncValue);

    bool downloadedLastExecution =
        asyncValue.value?.executionResult.Executions.any(
          (e) => e.Attachments.any((e) => e.FileExtension == downloadType.name),
        ) ??
        false;

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
            isLoading: asyncValue.isLoading,
            icon: Icon(isIOS ? CupertinoIcons.cloud_download : Icons.download),
            onPressed: hasAttachment ? null : onTap,
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
        const Spacer(),
        Consumer(
          builder: (_, ref, _) {
            if (!hasAttachment || fileBytes == null) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isXlsx && isMobilePlatform)
                  ShareButton(fileBytes: fileBytes, report: report)
                else if (isXlsx && !isMobilePlatform)
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
