import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';

class EcCommerceSiteDatasource implements IEcCommerceSiteDatasource {
  final HttpClient httpClient;

  const EcCommerceSiteDatasource(this.httpClient);

  @override
  Future<List<EcCommerceSiteModel>> getCommerceSites(
    EcRequestParams params,
    int enterpriseCode,
  ) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/Enterprises/CommerceSites',
      method: 'post',
      headers: params.toHeaders(),
      body: {...params.toMap(), 'EnterpriseCode': enterpriseCode},
    );

    return (response as List<dynamic>)
        .map((item) => EcCommerceSiteModel.fromJson(item as Map))
        .toList();
  }
}
