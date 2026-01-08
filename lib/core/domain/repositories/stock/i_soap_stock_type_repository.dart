import '../../entities/entities.dart';

abstract class ISoapStockTypeRepository {
  Future<List<StockTypeEntity>> load({
    required String urlInUse,
    required String crossIdentity,
  });
}
