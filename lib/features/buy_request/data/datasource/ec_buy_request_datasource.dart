import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/data/datasource/datasource.dart';

// TODO: Create tests for EcBuyRequest.
class EcBuyRequestDatasource implements IEcBuyRequestDatasource {
  final HttpClient httpClient;

  const EcBuyRequestDatasource(this.httpClient);

  @override
  Future<dynamic> loadShallow(
    EcRequestParams params, {
    required DateTime selectedDate,
  }) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/BuyRequest/Shallow',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'InitialCreateDate': selectedDate.toIso8601String(),
      },
    );

    return json.decode(response);
  }
}
