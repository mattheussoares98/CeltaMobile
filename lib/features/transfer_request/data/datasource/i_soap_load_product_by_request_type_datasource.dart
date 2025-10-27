import '../../../../core/data/models/models.dart';
import '../../../../core/domain/entities/entities.dart';

abstract class ISoapLoadProductByRequestTypeDatasource {
  Future<List<ProductModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseOriginCode,
    required int enterpriseDestinyCode,
    required int requestTypeCode,
    required String searchValue,
    required EnterpriseEntity enterpriseEntity,
    required SearchType searchType,
  });
}
