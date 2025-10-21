import '../entities/entities.dart';

abstract class ILocalPendingBuyRequestRepository {
  Future<PendingBuyRequestEntity?> load();
  Future<void> update(PendingBuyRequestEntity entity);
}
