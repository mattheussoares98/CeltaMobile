import 'products.dart';

abstract class ISoapGetProductsJsonDatasource {
  Future<List<ProductModelType>> get({
    required String baseUrl,
    required Map<String, dynamic> parametersPayload,
    required bool isCompetingPrices,
  });
}
