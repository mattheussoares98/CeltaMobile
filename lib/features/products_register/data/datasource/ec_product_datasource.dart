import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';

import 'datasource.dart';

class EcProductDatasource implements IEcProductDatasource {
  final HttpClient httpClient;
  EcProductDatasource(this.httpClient);

  @override
  Future<dynamic> get(EcRequestParams params) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/Products',
      method: 'get',
      headers: params.toHeaders(),
    );
    //TODO create tests
    return response;
  }
}
