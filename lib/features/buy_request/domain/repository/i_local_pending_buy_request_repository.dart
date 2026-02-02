import '../entities/entities.dart';

abstract class ILocalPendingBuyRequestRepository {
  Future<PendingBuyRequestEntity?> load(int enterpriseCode);
  Future<void> update(PendingBuyRequestEntity entity, int enterpriseCode);
}
