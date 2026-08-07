import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

class EcSellerDatasource implements IEcSellerDatasource {
  final HttpClient httpClient;
  EcSellerDatasource(this.httpClient);

  @override
  Future<List<EcSellerModel>> get(GetSellerParams params) async {
    final response = await httpClient.request(
      url:
          '${params.params.workingUrl}/api/Sellers?enterpriseCode=${params.enterpriseCode}',
      method: 'get',
      headers: params.params.toHeaders(),
    );
    return (response as List).map((e) => EcSellerModel.fromJson(e)).toList();
  }
}
