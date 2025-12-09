import '../entity/entity.dart';

abstract class ISoapLoadProductsNotFoundRepository {
  Future<List<ProductNotFoundEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required int receiptCode,
  });
}
