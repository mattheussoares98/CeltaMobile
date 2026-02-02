import '../models/models.dart';

abstract class ILocalPendingBuyRequestDatasource {
  Future<PendingBuyRequestModel?> load(int enterpriseCode);
  Future<void> update(PendingBuyRequestModel model, int enterpriseCode);
}
