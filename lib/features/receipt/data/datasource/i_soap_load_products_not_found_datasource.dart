import '../model/model.dart';

abstract class ISoapLoadProductsNotFoundDatasource {
  Future<List<ProductNotFoundModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required int receiptCode,
  });
}
