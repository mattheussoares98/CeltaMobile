import '../../entities/entities.dart';

abstract class ISoapProductsRepository {
  Future<List<ProductEntity>> getProductsJson({
    required String baseUrl,
    required String searchValue,
    required BsRoutine routine,
    required SearchType searchType,
    required String crossIdentity,
    required List<int> enterpriseCodes,
    required EnterpriseEntity enterpriseEntity,
    required int? lastBuyEntranceQuantity,
  });
}
