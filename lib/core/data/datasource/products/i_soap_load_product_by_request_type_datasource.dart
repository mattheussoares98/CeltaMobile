import '../../models/models.dart';

abstract class ISoapLoadProductByRequestTypeDatasource {
  Future<List<ProductModel>> load({
    required String urlInUse,
    required Map<String, dynamic> parametersPayload,
  });
}
