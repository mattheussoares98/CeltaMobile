import '../../models/models.dart';

abstract class ISoapLoadProductByRequestTypeDatasource {
  Future<List<ProductModel>> load({
    required String baseUrl,
    required Map<String, dynamic> parametersPayload,
  });
}
