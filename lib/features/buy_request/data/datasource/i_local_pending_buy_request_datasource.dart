import '../models/models.dart';

abstract class ILocalPendingBuyRequestDatasource {
  Future<PendingBuyRequestModel?> load();
  Future<void> update(PendingBuyRequestModel model);
}
