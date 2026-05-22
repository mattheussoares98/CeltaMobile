import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/reports/providers.dart';
import 'package:celta_inventario/features/reports/presentation/controllers/controllers.dart';

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

      ref
          .read(appUsageStateControllerProvider.notifier)
          .addUsage(UsageType.generateReport);

      await ref
          .read(soapExecuteOrDownloadScheduleRepositoryProvider)
          .executeOrDownloadSchedule(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            reportScheduleCode: reportScheduleCode,
            execute: true,
            sendEmailOnExecution: sendEmailOnExecution,
            downloadPdf: false,
            downloadXlsx: false,
          );

      ref
          .read(reportsStateControllerProvider.notifier)
          .updateExecutionDate(reportScheduleCode);
    });
  }
}
