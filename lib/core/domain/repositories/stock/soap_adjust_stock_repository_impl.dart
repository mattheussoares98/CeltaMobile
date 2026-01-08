import 'package:celta_intelligence/core/domain/entities/stock/adjust_stock_item_entity.dart';

import '../../../data/datasource/stock/stock.dart';
import '../../../data/models/models.dart';
import 'stock.dart';

class SoapAdjustStockRepositoryImpl implements ISoapAdjustStockRepository {
  final ISoapAdjustStockDatasource datasource;
  SoapAdjustStockRepositoryImpl(this.datasource);

  @override
  Future<void> confirm({
    required String workingUrl,
    required String crossIdentity,
    required List<AdjustStockItemEntity> items,
  }) async {
    await datasource.confirm(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      items: items.map((e) => AdjustStockItemModel.fromEntity(e)).toList(),
    );
  }
}
