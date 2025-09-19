import '../../../domain/entities/entities.dart';
import '../../models/models.dart';

abstract class ISoapProductsDatasource {
  Future<List<ProductModel>> getProductsJson({
    required String baseUrl,
    required String searchValue,
    required Routine routine,
    required SearchType searchType,
    required String crossIdentity,
    required List<int> enterpriseCodes,
    required EnterpriseEntity enterpriseEntity,
    int? lastBuyEntranceQuantity,
  });
}
