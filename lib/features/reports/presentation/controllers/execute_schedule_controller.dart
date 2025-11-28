import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../providers.dart';

part 'execute_schedule_controller.g.dart';

@riverpod
class ExecuteScheduleController extends _$ExecuteScheduleController {
  @override
  FutureOr<void> build(int reportScheduleCode) {}

  Future<void> execute(bool sendEmailOnExecution) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );
      await ref
          .read(soapExecuteOrDownloadScheduleRepositoryProvider)
          .executeOrDownloadSchedule(
            baseUrl: validatedUser!.enterprise!.baseUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            reportScheduleCode: reportScheduleCode,
            execute: true,
            sendEmailOnExecution: sendEmailOnExecution,
            downloadPdf: false,
            downloadXlsx: false,
          );

      //TODO update the last execution date in reports
    });
  }
}
