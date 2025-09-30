import 'package:celta_intelligence/core/domain/entities/stock/adjust_stock_item_entity.dart';

import '../../../../core/data/models/models.dart';
import '../../data/datasource/datasource.dart';
import 'repositories.dart';

class LocalItemsLotRepositoryImpl implements ILocalItemsLotRepository {
  final ILocalItemsLotDatasource datasource;
  LocalItemsLotRepositoryImpl(this.datasource);

  @override
  Future<void> addItem(AdjustStockItemEntity item) async {
    await datasource.addItem(AdjustStockItemModel.fromEntity(item));
  }

  @override
  Future<void> clear(int enterpriseCode) async {
    await datasource.clear(enterpriseCode);
  }

  @override
  Future<List<AdjustStockItemEntity>> load(int enterpriseCode) async {
    final items = await datasource.load(enterpriseCode);
    return items.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> removeItem(AdjustStockItemEntity item) async {
    await datasource.removeItem(AdjustStockItemModel.fromEntity(item));
  }
}
