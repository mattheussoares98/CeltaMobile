import '../../models/models.dart';

abstract class ISoapAdjustStockDatasource {
  Future<void> confirm({
    required String baseUrl,
    required String crossIdentity,
    required List<AdjustStockItemModel> items,
  });
}
