import '../models/models.dart';

abstract class ILocalSaleRequestDatasource {
  Future<void> save(SoapSaleRequestModel value, int enterpriseCode);
  Future<SoapSaleRequestModel?> load(int enterpriseCode);
  Future<void> clear(int enterpriseCode);
}
