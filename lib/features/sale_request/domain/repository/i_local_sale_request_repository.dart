import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

abstract class ILocalSaleRequestRepository {
  Future<void> save(SaleRequestEntity value, int enterpriseCode);
  Future<SaleRequestEntity?> load(int enterpriseCode);
  Future<void> clear(int enterpriseCode);
}
