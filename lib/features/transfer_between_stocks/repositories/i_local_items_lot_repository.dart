import '../../../core/domain/entities/entities.dart';

abstract class ILocalItemsLotRepository {
  Future<void> addItem(AdjustStockItemEntity item);
  Future<void> removeItem(AdjustStockItemEntity item);
  Future<List<AdjustStockItemEntity>> load();
  Future<void> clear();
}
