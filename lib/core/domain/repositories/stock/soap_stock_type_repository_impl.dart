import 'package:celta_intelligence/core/domain/entities/stock/stock_type_entity.dart';

import '../../../data/datasource/stock/stock.dart';
import 'stock.dart';

class SoapStockTypeRepositoryImpl implements ISoapStockTypeRepository {
  ISoapStockTypeDatasource datasource;

  SoapStockTypeRepositoryImpl(this.datasource);
  @override
  Future<List<StockTypeEntity>> load({
    required String urlInUse,
    required String crossIdentity,
  }) async {
    final value = await datasource.load(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
    );

    return value.map((e) => e.toEntity()).toList();
  }
}
