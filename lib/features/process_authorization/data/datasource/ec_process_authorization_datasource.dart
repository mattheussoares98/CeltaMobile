import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/ec/ec_request_params.dart';
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

import 'datasource.dart';

class EcProcessAuthorizationDatasource
    implements IEcProcessAuthorizationDatasource {
  final HttpClient httpClient;

  EcProcessAuthorizationDatasource(this.httpClient);

  @override
  Future<List<BSFProcessAuthorizationJudgmentModel>> getJudgments(
    EcRequestParams params, {
    int? processCode,
  }) async {
    final response = await httpClient.request(
      url:
          '${params.workingUrl}/api/ProcessAuthorization/Judgment'
          '?processCode=${processCode ?? -1}', //!-1 search the summary
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

  @override
  Future<BSFSaleRequestErrorModel> getSaleRequestErrors(
    EcRequestParams params, {
    required int enterpriseCode,
    required int saleRequestCode,
    required int customerCode,
    required SaleRequestErrorType errorType,
  }) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/ProcessAuthorization/SaleRequestErrors',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'EnterpriseCode': enterpriseCode,
        'SaleRequestCode': saleRequestCode,
        'CustomerCode': customerCode,
        'ErrorType': errorType.code,
      },
    );

    return BSFSaleRequestErrorModel.fromJson(json.decode(response));
  }

  @override
  Future<void> vote(
    EcRequestParams params, {
    required int processCode,
    required bool authorized,
    String? observations,
  }) async {
    await httpClient.request(
      url: '${params.workingUrl}/api/ProcessAuthorization/Vote',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'ProcessCode': processCode,
        'Authorized': authorized,
        'Observations': observations,
      },
    );
  }

  @override
  Future<dynamic> getGRDocFiscalNoteDifferences(
    EcRequestParams params,
    int documentCode,
  ) async {
    //TODO create tests
    final response = await httpClient.request(
      url:
          '${params.workingUrl}/api/ProcessAuthorization/GetGRDocFiscalNoteDifferences',
      method: 'post',
      headers: params.toHeaders(),
      body: {...params.toMap(), 'documentCode': documentCode},
    );

    return json.decode(response);
  }
}
