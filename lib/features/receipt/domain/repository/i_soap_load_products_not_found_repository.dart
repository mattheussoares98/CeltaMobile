import '../entity/entity.dart';

abstract class ISoapLoadProductsNotFoundRepository {
  Future<List<ProductNotFoundEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required int receiptCode,
  });
}
