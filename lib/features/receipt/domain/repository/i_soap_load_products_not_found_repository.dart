import '../entity/entity.dart';

abstract class ISoapLoadProductsNotFoundRepository {
  Future<List<ProductNotFoundEntity>> load({
    required String urlInUse,
    required String crossIdentity,
    required int receiptCode,
  });
}
