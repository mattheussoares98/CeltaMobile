import '../../entities/entities.dart';

abstract class ISoapStockTypeRepository {
  Future<List<StockTypeEntity>> load({
    required String baseUrl,
    required String crossIdentity,
  });
}
