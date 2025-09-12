import '../../../core/data/datasource/products/products.dart';
import '../entities/entities.dart';
import 'repositores.dart';

class SoapProductsRepositoryImpl implements ISoapProductsRepository {
  final ISoapProductsDataSource soapProductsDataSource;
  SoapProductsRepositoryImpl(this.soapProductsDataSource);

  @override
  Future<List<ProductEntity>> getProductsJson({
    required String baseUrl,
    required String searchValue,
    required Routine routine,
    required SearchType searchType,
    required String crossIdentity,
    required List<int> enterpriseCodes,
    required EnterpriseEntity enterpriseEntity,
    int? lastBuyEntranceQuantity,
  }) async {
    return await soapProductsDataSource
        .getProductsJson(
          baseUrl: baseUrl,
          searchValue: searchValue,
          routine: routine,
          searchType: searchType,
          crossIdentity: crossIdentity,
          enterpriseCodes: enterpriseCodes,
          enterpriseEntity: enterpriseEntity,
          lastBuyEntranceQuantity: lastBuyEntranceQuantity,
        )
        .then((products) {
          return products.map((e) => e.toEntity()).toList();
        });
  }
}
