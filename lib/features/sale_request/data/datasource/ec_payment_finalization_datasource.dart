import 'dart:convert';

import '../../../../core/data/models/models.dart';
import '../../../../core/domain/contracts/contracts.dart';
import '../../../../core/domain/entities/entities.dart';
import 'datasource.dart';

class EcPaymentFinalizationDatasource
    implements IEcPaymentFinalizationDatasource {
  final HttpClient httpClient;
  EcPaymentFinalizationDatasource(this.httpClient);

  @override
  Future<List<BSFPaymentFinalizationModel>> getPaymentFinalizations({
    required int enterpriseCode,
    required EcRequestParams params,
  }) async {
    final response = await httpClient.request(
      url:
          '${params.workingUrl}/api/PaymentFinalization/GetPaymentFinalization?enterpriseCode=$enterpriseCode',
      method: 'post',
      headers: params.toHeaders(),
      body: params.toMap(),
    );

    return (json.decode(response) as List)
        .map(
          (e) =>
              BSFPaymentFinalizationModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<BSFPaymentConditionModel>> getPaymentConditions({
    required EcRequestParams params,
  }) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/PaymentFinalization/GetPaymentConditions',
      method: 'post',
      headers: params.toHeaders(),
      body: params.toMap(),
    );

    return (json.decode(response) as List)
        .map(
          (e) => BSFPaymentConditionModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
