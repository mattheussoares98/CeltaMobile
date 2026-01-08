import '../../models/models.dart';

abstract class ISoapAdjustStockDatasource {
  Future<void> confirm({
    required String urlInUse,
    required String crossIdentity,
    required List<AdjustStockItemModel> items,
  });
}
