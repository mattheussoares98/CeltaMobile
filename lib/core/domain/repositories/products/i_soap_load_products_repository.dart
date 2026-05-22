import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class ISoapLoadProductsRepository {
  Future<List<ProductEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required EnterpriseEntity enterpriseEntity,
    required GetProductsDefaultParams getProductsDefaultParams,
    required SearchType searchType,
  });
}
