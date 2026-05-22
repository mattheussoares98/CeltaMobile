import 'package:celta_inventario/features/sale_request/data/models/models.dart';

abstract class ILocalSaleRequestDatasource {
  Future<void> save(SoapSaleRequestModel value, int enterpriseCode);
  Future<SoapSaleRequestModel?> load(int enterpriseCode);
  Future<void> clear(int enterpriseCode);
}
