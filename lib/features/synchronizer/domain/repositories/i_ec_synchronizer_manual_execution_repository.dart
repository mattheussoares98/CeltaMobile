// lib/features/synchronizer/domain/repositories/i_ec_synchronizer_manual_execution_repository.dart
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

abstract class IEcSynchronizerManualExecutionRepository {
  Future<List<ManualExecutionScheduleEntity>> searchManualExecutionSchedules(
    EcRequestParams ecParams,
    SearchManualExecutionSchedulesParametersEntity parameters,
  );

  Future<void> executeManualSchedule(
    EcRequestParams ecParams,
    ExecuteManualScheduleParametersEntity parameters,
  );
}
