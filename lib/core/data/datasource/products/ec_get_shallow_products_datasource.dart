import 'package:celta_inventario/core/data/datasource/products/products.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';

class EcGetShallowProductsDatasource
    implements IEcGetShallowProductsDatasource {
  final HttpClient httpClient;
  EcGetShallowProductsDatasource(this.httpClient);

  @override
  Future<List<ShallowProductModel>> get({
    required String workingUrl,
    required String name,
    required int enterpriseId,
    required String user,
    required String accessKey,
    required CancelToken? cancelToken,
    int? recordsByPage,
  }) async {
    final response = await httpClient.request(
      url: '$workingUrl/api/products/shallow',
      method: 'post',
      headers: {'user': user, 'accessKey': accessKey},
      body: {
        'name': name,
        'enterpriseId': enterpriseId,
        'recordsByPage': recordsByPage,
      },
      cancelToken: cancelToken,
    );

    if (response == null) {
      return [];
    }

    return (response as List)
        .map((e) => ShallowProductModel.fromJson(e))
        .toList();
  }
}
