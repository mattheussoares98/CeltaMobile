import 'package:celta_inventario/features/buy_request/data/models/models.dart';

abstract class ILocalPendingBuyRequestDatasource {
  Future<PendingBuyRequestModel?> load(int enterpriseCode);
  Future<void> update(PendingBuyRequestModel model, int enterpriseCode);
}
