// lib/features/synchronizer/presentation/controllers/manual_execution_schedules_state_controller.dart
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manual_execution_schedules_state_controller.g.dart';

@riverpod
class ManualExecutionSchedulesStateController
    extends _$ManualExecutionSchedulesStateController {
  @override
  FutureOr<List<ManualExecutionScheduleEntity>> build(
    int enterpriseCode,
  ) async {
    ref.cache(300);

    final ecParams = await ref.watch(ecRequestParamsProvider().future);

    final repository = ref.read(
      ecSynchronizerManualExecutionRepositoryProvider,
    );
    return await repository.searchManualExecutionSchedules(
      ecParams,
      SearchManualExecutionSchedulesParametersEntity(
        enterpriseCode: enterpriseCode,
      ),
    );
  }
}
