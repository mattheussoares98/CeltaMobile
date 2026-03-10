import '../../../domain/contracts/contracts.dart';
import '../../models/models.dart';
import 'products.dart';

class EcommerceGetShallowProductsDatasource
    implements IEcommerceGetShallowProductsDatasource {
  final HttpClient httpClient;
  EcommerceGetShallowProductsDatasource(this.httpClient);

  @override
  Future<List<ShallowProductModel>> get({
    required String workingUrl,
    required String name,
    required int enterpriseId,
    required String user,
    required String accessKey,
  }) async {
    final response = await httpClient.request(
      url: '$workingUrl/api/products/shallow',
      method: 'post',
      headers: {'user': user, 'accessKey': accessKey},
      body: {'name': name, 'enterpriseId': enterpriseId, 'recordsByPage': 10},
    );

    return (response as List)
        .map((e) => ShallowProductModel.fromJson(e))
        .toList();
  }
}
