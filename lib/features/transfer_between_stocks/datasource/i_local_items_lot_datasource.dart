import '../../../core/data/models/models.dart';

abstract class ILocalItemsLotDatasource {
  Future<void> addItem(AdjustStockItemModel item);
  Future<void> removeItem(AdjustStockItemModel item);
  Future<List<AdjustStockItemModel>> load();
  Future<void> clear();
}
