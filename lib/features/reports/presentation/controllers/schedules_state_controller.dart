import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'schedules_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SchedulesStateController extends _$SchedulesStateController {
  @override
  FutureOr<ScheduleExecutionsEntity?> build(int reportScheduleCode) {
    return null;
  }

  Future<void> download({
    required bool downloadPdf,
    required bool downloadXlsx,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final response = await ref
          .read(soapExecuteOrDownloadScheduleRepositoryProvider)
          .executeOrDownloadSchedule(
            baseUrl: validatedUser!.enterprise!.baseUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            reportScheduleCode: reportScheduleCode,
            execute: false,
            sendEmailOnExecution: false,
            downloadPdf: downloadPdf,
            downloadXlsx: downloadXlsx,
          );

      return response.first;
    });
  }
}
