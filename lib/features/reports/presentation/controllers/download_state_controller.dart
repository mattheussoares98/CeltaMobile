import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/datasource/share_download/share_download.dart';
import '../../../../core/presentation/controllers/share_download/share_download.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'download_state_controller.g.dart';

@Riverpod(keepAlive: true)
class DownloadStateController extends _$DownloadStateController {
  @override
  FutureOr<DownloadExecutionEntity?> build(
    int reportScheduleCode,
    DownloadType downloadType,
  ) {
    return null;
  }

  Future<void> download(TargetPlatform platform, String modelName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );

      final response = await ref
          .read(soapExecuteOrDownloadScheduleRepositoryProvider)
          .executeOrDownloadSchedule(
            urlInUse: validatedUser!.enterprise!.urlInUse!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            reportScheduleCode: reportScheduleCode,
            execute: false,
            sendEmailOnExecution: false,
            downloadPdf: downloadType == DownloadType.pdf,
            downloadXlsx: downloadType == DownloadType.xlsx,
          );

      if (platform != TargetPlatform.android &&
          platform != TargetPlatform.iOS &&
          downloadType == DownloadType.xlsx) {
        final file = FileProperties(
          name: modelName,
          bytes: response.first.Executions.first.Attachments
              .firstWhere((e) => e.FileExtension == DownloadType.xlsx.name)
              .AttachmentBase64,
          extension: '.xlsx',
          mimeType:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        );
        final filePath = await ref
            .read(shareDownloadControllerProvider.notifier)
            .download(file, platform);
        return DownloadExecutionEntity(
          executionResult: response.first,
          xlsxFilePath: filePath,
        );
      }

      return DownloadExecutionEntity(executionResult: response.first);
    });
  }
}
