// lib/features/synchronizer/presentation/controllers/execute_manual_schedule_controller.dart
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'execute_manual_schedule_controller.g.dart';

@riverpod
class ExecuteManualScheduleController
    extends _$ExecuteManualScheduleController {
  @override
  FutureOr<void> build({
    required int enterpriseCode,
    required int scheduleCode,
  }) {
    ref.cache(300);
  }

  Future<bool> execute() async {
    bool succeeds = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final ecParams = await ref.read(ecRequestParamsProvider().future);

      final repository = ref.read(
        ecSynchronizerManualExecutionRepositoryProvider,
      );
      await repository.executeManualSchedule(
        ecParams,
        ExecuteManualScheduleParametersEntity(
          enterpriseCode: enterpriseCode,
          scheduleCode: scheduleCode,
        ),
      );
      succeeds = true;
    });
    return succeeds;
  }
}
