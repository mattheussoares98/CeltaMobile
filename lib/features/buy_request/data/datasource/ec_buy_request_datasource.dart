import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/buy_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_request/data/models/models.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';

class EcBuyRequestDatasource implements IEcBuyRequestDatasource {
  final HttpClient httpClient;

  const EcBuyRequestDatasource(this.httpClient);

  @override
  Future<List<EcBuyRequestDtoModel>> loadShallow(
    LoadShallowBuyRequestParams params,
  ) async {
    final response = await httpClient.request(
      url: '${params.requestParams.workingUrl}/api/BuyRequest/Shallow',
      method: 'post',
      headers: params.requestParams.toHeaders(),
      body: {
        ...params.requestParams.toMap(),
        'InitialCreateDate': params.selectedDate.toIso8601String(),
        'EnterpriseCode': params.enterpriseCode,
      },
    );

    return (response as List)
        .map((e) => EcBuyRequestDtoModel.fromJson(e as Map))
        .toList();
  }

  @override
  Future<EcBuyRequestDtoModel> loadDetails(
    LoadBuyRequestDetailsParams params,
  ) async {
    final response = await httpClient.request(
      url: '${params.requestParams.workingUrl}/api/BuyRequest/Details',
      method: 'post',
      headers: params.requestParams.toHeaders(),
      body: {
        ...params.requestParams.toMap(),
        'BuyRequestCode': params.buyRequestCode,
      },
    );

    return EcBuyRequestDtoModel.fromJson(response as Map);
  }
}
