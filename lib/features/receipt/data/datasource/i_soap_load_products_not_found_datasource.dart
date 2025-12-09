import '../model/model.dart';

abstract class ISoapLoadProductsNotFoundDatasource {
  Future<List<ProductNotFoundModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required int receiptCode,
  });
}
