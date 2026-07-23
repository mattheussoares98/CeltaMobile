import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/buy_movement/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_movement/data/models/models.dart';
import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';

class EcBuyMovementDatasource implements IEcBuyMovementDatasource {
  final HttpClient httpClient;

  const EcBuyMovementDatasource(this.httpClient);

  @override
  Future<List<EcBuyMovementDtoModel>> loadShallow(
    LoadShallowBuyMovementParams params,
  ) async {
    final response = await httpClient.request(
      url: '${params.requestParams.workingUrl}/api/BuyMovements/Shallow',
      method: 'post',
      headers: params.requestParams.toHeaders(),
      body: {
        ...params.requestParams.toMap(),
        'InitialEntranceDate': params.selectedDate.toIso8601String(),
        'EnterpriseCode': params.enterpriseCode,
      },
    );

    return (response as List)
        .map((e) => EcBuyMovementDtoModel.fromJson(e as Map))
        .toList();
  }

  @override
  Future<EcBuyMovementDtoModel> loadDetails(
    LoadBuyMovementDetailsParams params,
  ) async {
    final response = await httpClient.request(
      url: '${params.requestParams.workingUrl}/api/BuyMovements/Details',
      method: 'post',
      headers: params.requestParams.toHeaders(),
      body: {
        ...params.requestParams.toMap(),
        'BuyMovementCode': params.buyMovementCode,
      },
    );

    return EcBuyMovementDtoModel.fromJson(response as Map);
  }
}
