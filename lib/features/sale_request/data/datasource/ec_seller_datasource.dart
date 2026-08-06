import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';

class EcSellerDatasource implements IEcSellerDatasource {
  final HttpClient httpClient;
  EcSellerDatasource(this.httpClient);

  @override
  Future<List<EcSellerModel>> get(EcRequestParams params) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/Sellers',
      method: 'get',
      headers: params.toHeaders(),
    );
    //TODO should return only sellers which the user has access
    return (response as List).map((e) => EcSellerModel.fromJson(e)).toList();
  }
}
