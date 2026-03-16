import '../entities/entities.dart';

abstract class ILocalPendingSaleRequestRepository {
  Future<void> save(SaleRequestEntity value, int enterpriseCode);
  Future<SaleRequestEntity?> load(int enterpriseCode);
  Future<void> clear(int enterpriseCode);
}
