import '../../../../core/data/models/models.dart';

// The contract
abstract class ILocalItemsLotDatasource {
  Future<void> addItem(AdjustStockItemModel item);
  Future<void> removeItem(AdjustStockItemModel item);
  Future<List<AdjustStockItemModel>> load(int enterpriseCode);
  Future<void> clear(int enterpriseCode);
}
