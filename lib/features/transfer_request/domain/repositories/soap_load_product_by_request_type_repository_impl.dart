import '../../../../core/domain/entities/entities.dart';
import '../../data/datasource/datasource.dart';
import 'repositories.dart';

class SoapLoadProductByRequestTypeRepositoryImpl
    implements ISoapLoadProductByRequestTypeRepository {
  ISoapLoadProductByRequestTypeDatasource datasource;
  SoapLoadProductByRequestTypeRepositoryImpl(this.datasource);

  @override
  Future<List<ProductEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseOriginCode,
    required int enterpriseDestinyCode,
    required int requestTypeCode,
    required String searchValue,
    required EnterpriseEntity enterpriseEntity,
    required SearchType searchType,
  }) async {
    final response = await datasource.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseOriginCode: enterpriseOriginCode,
      enterpriseDestinyCode: enterpriseDestinyCode,
      requestTypeCode: requestTypeCode,
      searchValue: searchValue,
      enterpriseEntity: enterpriseEntity,
      searchType: searchType,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
