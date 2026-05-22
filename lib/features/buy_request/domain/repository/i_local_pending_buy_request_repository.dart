import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';

abstract class ILocalPendingBuyRequestRepository {
  Future<PendingBuyRequestEntity?> load(int enterpriseCode);
  Future<void> update(PendingBuyRequestEntity entity, int enterpriseCode);
}
