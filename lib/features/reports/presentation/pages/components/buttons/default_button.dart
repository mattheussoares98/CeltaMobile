import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/reports/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/reports/presentation/pages/components/buttons/buttons.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultButton extends ConsumerWidget {
  final DownloadType downloadType;
  final ReportScheduleEntity report;
  const DefaultButton(this.downloadType, this.report, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isXlsx = downloadType == DownloadType.xlsx;

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
            .download(context.theme.platform, report.ReportModelName);
      }

      if (isXlsx) {
        final filePath = ref.read(
          downloadStateControllerProvider(
            report.Code,
            downloadType,
          ).select((s) => s.value?.xlsxFilePath),
        );
        if (filePath != null && context.mounted) {
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

    return Column(
      children: [
        FittedBox(
          child: PrimaryTextButton(
            color: downloadedLastExecution ? context.theme.disabledColor : null,
            textAlign: TextAlign.start,
            text: hasAttachment
                ? (isXlsx
                      ? 'Planilha baixada'.hardcoded
                      : 'PDF baixado'.hardcoded)
                : (isXlsx
                      ? 'Baixar planilha'.hardcoded
                      : 'Baixar PDF'.hardcoded),
            isLoading: isLoading,
            platformIcon: const PlatformIcon(
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

            return Padding(
              padding: const EdgeInsets.only(bottom: Sizes.p8),
              child: Text(
                error.toString(),
                style: context.theme.textTheme.bodySmall?.copyWith(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          },
        ),
        Consumer(
          builder: (_, ref, _) {
            final Uint8List? fileBytes = extractBytes();

            if (!hasAttachment || fileBytes == null || kIsWeb) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isXlsx && !PlatformUtil.isDesktop)
                  ShareButton(fileBytes: fileBytes, report: report)
                else if (isXlsx && PlatformUtil.isDesktop)
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
