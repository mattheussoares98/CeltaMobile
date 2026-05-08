import 'dart:convert';

import '../../../../core/domain/contracts/contracts.dart';
import '../../../../core/domain/entities/entities.dart';
import '../models/models.dart';
import 'datasource.dart';

class EcPaymentFinalizationDatasource implements IEcPaymentFinalizationDatasource {
  final HttpClient httpClient;
  EcPaymentFinalizationDatasource(this.httpClient);

  @override
  Future<List<BSFPaymentFinalizationModel>> getPaymentOptions({
    required int enterpriseCode,
    required EcRequestParams params,
  }) async {
    final response = await httpClient.request(
      url:
          '${params.workingUrl}/api/PaymentFinalization/GetPaymentOptions?enterpriseCode=$enterpriseCode',
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
}
