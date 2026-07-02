import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/ec/ec_request_params.dart';
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';

import 'datasource.dart';

class EcProcessAuthorizationDatasource
    implements IEcProcessAuthorizationDatasource {
  final HttpClient httpClient;

  EcProcessAuthorizationDatasource(this.httpClient);

  @override
  Future<List<BSFProcessAuthorizationJudgmentModel>> getJudgments(
    EcRequestParams params,
  ) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/ProcessAuthorization/Judgment',
      method: 'post',
      headers: params.toHeaders(),
      body: params.toMap(),
    );

    return (json.decode(response) as List)
        .map((e) => BSFProcessAuthorizationJudgmentModel.fromJson(e))
        .toList();
  }

  @override
  Future<BsfProcessAuthorizationStatisticModel> getStatistics(
    EcRequestParams params,
  ) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/ProcessAuthorization/Statistics',
      method: 'post',
      headers: params.toHeaders(),
      body: params.toMap(),
    );

    return BsfProcessAuthorizationStatisticModel.fromJson(
      json.decode(response) as Map,
    );
  }
}
