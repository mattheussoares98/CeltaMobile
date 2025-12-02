import 'products.dart';

abstract class ISoapInventoryLoadProductsDatasource {
  Future<List<ProductModelType>> get({
    required String baseUrl,
    required Map<String, dynamic> parametersPayload,
  });
}
