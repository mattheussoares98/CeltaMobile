import '../../../data/datasource/products/products.dart';
import '../../entities/entities.dart';
import 'products.dart';

class SoapProductsRepositoryImpl implements ISoapProductsRepository {
  final ISoapProductsDatasource soapProductsDatasource;
  SoapProductsRepositoryImpl(this.soapProductsDatasource);

  @override
  Future<List<ProductEntity>> getProductsJson({
    required String baseUrl,
    required String searchValue,
    required BsRoutine routine,
    required SearchType searchType,
    required String crossIdentity,
    required List<int> enterpriseCodes,
    required EnterpriseEntity enterpriseEntity,
    required int? lastBuyEntranceQuantity,
    BuyRequestFilters? buyRequestFilters,
    CompetingPricesFilters? competingPricesFilters,
  }) async {
    return await soapProductsDatasource
        .getProductsJson(
          baseUrl: baseUrl,
          searchValue: searchValue,
          routine: routine,
          searchType: searchType,
          crossIdentity: crossIdentity,
          enterpriseCodes: enterpriseCodes,
          enterpriseEntity: enterpriseEntity,
          lastBuyEntranceQuantity: lastBuyEntranceQuantity,
          buyRequestFilters: buyRequestFilters,
          competingPricesFilters: competingPricesFilters,
        )
        .then((products) {
          return products.map((e) => e.toEntity()).toList();
        });
  }
}
