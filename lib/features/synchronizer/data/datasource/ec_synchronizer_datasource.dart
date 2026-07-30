import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

import 'datasource.dart';

class EcSynchronizerDatasource implements IEcSynchronizerDatasource {
  final HttpClient httpClient;

  const EcSynchronizerDatasource(this.httpClient);

  @override
  Future<List<SynchronizerErrorSummaryModel>> searchCount(
    EcRequestParams params,
  ) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/Synchronizer',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'Operation': SynchronizerErrorSearchOperation.searchCount.value,
      },
    );

    return (response as List<Map>)
        .map(SynchronizerErrorSummaryModel.fromJson)
        .toList();
  }

  @override
  Future<SynchronizerErrorDetailsModel> searchByKey(
    EcRequestParams params, {
    required String errorKey,
  }) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/Synchronizer',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'Operation': SynchronizerErrorSearchOperation.searchByKey.value,
        'ErrorKey': errorKey,
      },
    );

    return SynchronizerErrorDetailsModel.fromJson(response as Map);
  }
}
