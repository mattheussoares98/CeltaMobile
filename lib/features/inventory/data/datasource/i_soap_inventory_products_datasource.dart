import '../../../../core/domain/entities/entities.dart';
import '../models/models.dart';

abstract class ISoapInventoryProductsDatasource {
  Future<List<InventoryProductModel>> getProductsJson({
    required String baseUrl,
    required String searchValue,
    required int inventoryProcessCode,
    required SearchType searchType,
    required String crossIdentity,
    required int enterpriseCode,
    required int inventoryCountingCode,
    required EnterpriseEntity selectedEnterprise,
  });
}
