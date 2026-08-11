// lib/features/synchronizer/data/repositories/ec_synchronizer_manual_execution_repository_impl.dart
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';

class EcSynchronizerManualExecutionRepositoryImpl
    implements IEcSynchronizerManualExecutionRepository {
  final IEcSynchronizerManualExecutionDatasource datasource;

  const EcSynchronizerManualExecutionRepositoryImpl(this.datasource);

  @override
  Future<List<ManualExecutionEnterpriseEntity>>
  searchManualExecutionEnterprises(
    EcRequestParams ecParams,
    SearchManualExecutionEnterprisesParamsEntity parameters,
  ) async {
    final models = await datasource.searchManualExecutionEnterprises(
      ecParams,
      SearchManualExecutionEnterprisesParametersModel.fromEntity(parameters),
    );

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<ManualExecutionScheduleEntity>> searchManualExecutionSchedules(
    EcRequestParams ecParams,
    SearchManualExecutionSchedulesParametersEntity parameters,
  ) async {
    final models = await datasource.searchManualExecutionSchedules(
      ecParams,
      SearchManualExecutionSchedulesParametersModel.fromEntity(parameters),
    );

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> executeManualSchedule(
    EcRequestParams ecParams,
    ExecuteManualScheduleParametersEntity parameters,
  ) async {
    await datasource.executeManualSchedule(
      ecParams,
      ExecuteManualScheduleParametersModel.fromEntity(parameters),
    );
  }
}
