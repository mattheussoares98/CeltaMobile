import '../../entities/entities.dart';

abstract class ISoapLoadProductsRepository {
  Future<List<ProductEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required EnterpriseEntity enterpriseEntity,
    required GetProductsJsonParams getProductsJsonParams,
  });
}
