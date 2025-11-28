import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/data/datasource/share_download/share_download.dart';
import '../../../../../core/presentation/controllers/share_download/share_download.dart';
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

  Uint8List? _extractBytes(AsyncValue<DownloadExecutionEntity?> asyncValue) {
    return asyncValue.value?.executionResult.Executions
        .firstWhereOrNull((e) => e.Attachments.isNotEmpty)
        ?.Attachments
        .firstWhereOrNull((e) => e.FileExtension == downloadType.name)
        ?.AttachmentBase64;
  }

  void _openFile(BuildContext context, String filePath) async {
    final response = await OpenFile.open(filePath);
    if (response.type == ResultType.error) {
      showAlertDialog(
        context: context,
        title: 'Erro!'.hardcoded,
        content:
            'Não foi possível abrir o arquivo. Confirme se você possui um aplicativo padrão instalado para abrir esse tipo de arquivos de planilha'
                .hardcoded,
      );
    }
  }

  void _onTap(
    BuildContext context,
    Uint8List? bytes,
    bool isXlsx,
    String modelName,
    WidgetRef ref,
    bool showDialog,
  ) async {
    //TODO test this feature in all platforms
    if (isXlsx) {
      // Logic for opening the Excel file
      final filePath = ref.read(
        downloadStateControllerProvider(
          report.Code,
          downloadType,
        ).select((s) => s.value?.xlsxFilePath),
      );
      if (filePath != null) {
        // Show dialog and then open file
        if (showDialog) {
          showAlertDialog(
            context: context,
            title: 'Planilha baixada'.hardcoded,
            content: 'Planilha baixada em "$filePath"'.hardcoded,
            defaultActionText: 'Abrir arquivo'.hardcoded,
            cancelActionText: 'Ok'.hardcoded,
            onOkPressed: () => _openFile(context, filePath),
          );
        } else {
          _openFile(context, filePath);
        }
      }
    } else {
      // Logic for viewing the PDF
      context.pushNamed(
        Routes.pdfViewer.name,
        extra: <String, dynamic>{'bytes': bytes, 'fileName': modelName},
      );
    }
  }

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
    final Uint8List? fileBytes = _extractBytes(asyncValue);

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
              : 1,
          child: PrimaryTextButton(
            color: downloadedLastExecution ? theme.disabledColor : null,
            textAlign: TextAlign.start,
            text: hasAttachment
                ? (isXlsx ? 'Planilha baixada' : 'PDF baixado')
                : (isXlsx
                      ? 'Baixar planilha'.hardcoded
                      : 'Baixar PDF'.hardcoded),
            isLoading: asyncValue.isLoading,
            icon: Icon(isIOS ? CupertinoIcons.cloud_download : Icons.download),
            onPressed: hasAttachment
                ? null
                : () async {
                    if (!isMobilePlatform && isXlsx) {
                      await showAlertDialog(
                        context: context,
                        title: 'Atenção'.hardcoded,
                        content: 'Selecione a pasta que deseja salvar o arquivo'
                            .hardcoded,
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
                    if (isXlsx) {
                      _onTap(
                        context,
                        fileBytes,
                        isXlsx,
                        report.ReportModelName,
                        ref,
                        true,
                      );
                    }
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
        const Spacer(),
        Consumer(
          builder: (_, ref, _) {
            if (!hasAttachment || fileBytes == null) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isXlsx || !isMobilePlatform)
                  InkWell(
                    onTap: () => _onTap(
                      context,
                      fileBytes,
                      isXlsx,
                      report.ReportModelName,
                      ref,
                      false,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.p4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          gapW4,
                          Text(
                            'Visualizar'.hardcoded,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.primaryColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          gapW8,
                          Icon(
                            isIOS ? CupertinoIcons.eye : Icons.remove_red_eye,
                            color: theme.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (isXlsx)
                  InkWell(
                    onTap: () {
                      ref
                          .read(shareDownloadControllerProvider.notifier)
                          .share(
                            FileProperties(
                              name: report.ReportModelName,
                              bytes: fileBytes,
                              extension: DownloadType.xlsx.name,
                            ),
                          );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.p4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          gapW4,
                          Text(
                            'Compartilhar'.hardcoded,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.primaryColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          gapW8,
                          Icon(
                            isIOS ? CupertinoIcons.share : Icons.share,
                            color: theme.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
