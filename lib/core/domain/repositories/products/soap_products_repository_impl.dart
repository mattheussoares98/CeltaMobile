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
    int? lastBuyEntranceQuantity,
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
        )
        .then((products) {
          return products.map((e) => e.toEntity()).toList();
        });
  }
}
