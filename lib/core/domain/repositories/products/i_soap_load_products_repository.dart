import '../../entities/entities.dart';

abstract class ISoapLoadProductsRepository {
  Future<List<ProductEntity>> load({
    required String urlInUse,
    required String crossIdentity,
    required EnterpriseEntity enterpriseEntity,
    required GetProductsDefaultParams getProductsDefaultParams,
    required SearchType searchType,
  });
}
