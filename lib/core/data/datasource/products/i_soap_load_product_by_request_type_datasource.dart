import '../../models/models.dart';

abstract class ISoapLoadProductByRequestTypeDatasource {
  Future<List<ProductModel>> load({
    required String workingUrl,
    required Map<String, dynamic> parametersPayload,
  });
}
