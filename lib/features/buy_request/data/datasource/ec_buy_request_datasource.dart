import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_request/data/models/models.dart';

// TODO: Create tests for EcBuyRequest.
class EcBuyRequestDatasource implements IEcBuyRequestDatasource {
  final HttpClient httpClient;

  const EcBuyRequestDatasource(this.httpClient);

  @override
  Future<List<EcBuyRequestDtoModel>> loadShallow(
    EcRequestParams params, {
    required DateTime selectedDate,
    required int enterpriseCode,
  }) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/BuyRequest/Shallow',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'InitialCreateDate': selectedDate.toIso8601String(),
        'EnterpriseCode': enterpriseCode,
      },
    );

    return (response as List)
        .map((e) => EcBuyRequestDtoModel.fromJson(e as Map))
        .toList();
  }
}
