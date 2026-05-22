import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class ISoapStockTypeRepository {
  Future<List<StockTypeEntity>> load({
    required String workingUrl,
    required String crossIdentity,
  });
}
