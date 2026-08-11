// lib/features/synchronizer/data/datasource/manual_execution_datasource.dart
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';

class EcSynchronizerManualExecutionDatasource
    implements IEcSynchronizerManualExecutionDatasource {
  final HttpClient httpClient;

  const EcSynchronizerManualExecutionDatasource(this.httpClient);

  @override
  Future<List<ManualExecutionEnterpriseModel>> searchManualExecutionEnterprises(
    EcRequestParams ecParams,
    SearchManualExecutionEnterprisesParametersModel parameters,
  ) async {
    final response = await httpClient.request(
      url:
          '${ecParams.workingUrl}/api/Synchronizer/SearchManualExecutionEnterprises',
      method: 'post',
      headers: ecParams.toHeaders(),
      body: {...ecParams.toMap(), ...parameters.toJson()},
    );

    return (response as List<dynamic>)
        .map((item) => ManualExecutionEnterpriseModel.fromJson(item as Map))
        .toList();
  }

  @override
  Future<List<ManualExecutionScheduleModel>> searchManualExecutionSchedules(
    EcRequestParams ecParams,
    SearchManualExecutionSchedulesParametersModel parameters,
  ) async {
    final response = await httpClient.request(
      url:
          '${ecParams.workingUrl}/api/Synchronizer/SearchManualExecutionSchedules',
      method: 'post',
      headers: ecParams.toHeaders(),
      body: {...ecParams.toMap(), ...parameters.toJson()},
    );

    return (response as List<dynamic>)
        .map((item) => ManualExecutionScheduleModel.fromJson(item as Map))
        .toList();
  }

  @override
  Future<void> executeManualSchedule(
    EcRequestParams ecParams,
    ExecuteManualScheduleParametersModel parameters,
  ) async {
    await httpClient.request(
      url: '${ecParams.workingUrl}/api/Synchronizer/ExecuteManualSchedule',
      method: 'post',
      headers: ecParams.toHeaders(),
      body: {...ecParams.toMap(), ...parameters.toJson()},
    );
  }
}
