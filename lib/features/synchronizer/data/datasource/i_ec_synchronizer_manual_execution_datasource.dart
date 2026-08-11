// lib/features/synchronizer/data/datasource/i_manual_execution_datasource.dart
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';

abstract class IEcSynchronizerManualExecutionDatasource {
  Future<List<ManualExecutionEnterpriseModel>> searchManualExecutionEnterprises(
    EcRequestParams ecParams,
    SearchManualExecutionEnterprisesParametersModel parameters,
  );

  Future<List<ManualExecutionScheduleModel>> searchManualExecutionSchedules(
    EcRequestParams ecParams,
    SearchManualExecutionSchedulesParametersModel parameters,
  );

  Future<void> executeManualSchedule(
    EcRequestParams ecParams,
    ExecuteManualScheduleParametersModel parameters,
  );
}
