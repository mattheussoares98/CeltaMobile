import '../../entities/entities.dart';

abstract class ISoapLoadProductsRepository {
  Future<List<ProductEntityType>> load({
    required String baseUrl,
    required String crossIdentity,
    required EnterpriseEntity enterpriseEntity,
    required GetProductsDefaultParams getProductsDefaultParams,
  });
}
