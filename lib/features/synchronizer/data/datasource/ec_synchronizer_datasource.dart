import 'dart:convert';

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

    return (response as List<dynamic>)
        .map((e) => SynchronizerErrorSummaryModel.fromJson(e as Map))
        .toList();
  }

  @override
  Future<SynchronizerErrorDetailsModel> searchByKey(
    EcRequestParams params,
    String errorKey,
  ) async {
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

    return SynchronizerErrorDetailsModel.fromJson(json.decode(response) as Map);
  }

  @override
  Future<void> markCouponsToReadAgain(
    EcRequestParams params,
    List<int> codes,
  ) async {
    await httpClient.request(
      url: '${params.workingUrl}/api/Synchronizer/MarkCouponsToReadAgain',
      method: 'post',
      headers: params.toHeaders(),
      body: {...params.toMap(), 'Codes': codes},
    );
  }

  @override
  Future<void> markSaleRequestsWithErrorToReadAgain(
    EcRequestParams params,
    List<int> codes,
  ) async {
    await httpClient.request(
      url:
          '${params.workingUrl}/api/Synchronizer/MarkSaleRequestsWithErrorToReadAgain',
      method: 'post',
      headers: params.toHeaders(),
      body: {...params.toMap(), 'Codes': codes},
    );
  }

  @override
  Future<void> deleteScheduleErrors(
    EcRequestParams params,
    List<int> codes,
  ) async {
    await httpClient.request(
      url: '${params.workingUrl}/api/Synchronizer/DeleteScheduleErrors',
      method: 'post',
      headers: params.toHeaders(),
      body: {...params.toMap(), 'Codes': codes},
    );
  }
}
