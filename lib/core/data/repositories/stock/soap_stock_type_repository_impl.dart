import 'package:celta_inventario/core/domain/entities/stock/stock_type_entity.dart';

import '../../../data/datasource/stock/stock.dart';
import 'package:celta_inventario/core/domain/repositories/stock/stock.dart';

class SoapStockTypeRepositoryImpl implements ISoapStockTypeRepository {
  ISoapStockTypeDatasource datasource;

  SoapStockTypeRepositoryImpl(this.datasource);
  @override
  Future<List<StockTypeEntity>> load({
    required String workingUrl,
    required String crossIdentity,
  }) async {
    final value = await datasource.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
    );

    return value.map((e) => e.toEntity()).toList();
  }
}
