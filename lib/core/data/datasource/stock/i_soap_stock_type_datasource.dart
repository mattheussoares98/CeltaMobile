import '../../models/models.dart';

abstract class ISoapStockTypeDatasource {
  Future<List<StockTypeModel>> load({
    required String urlInUse,
    required String crossIdentity,
  });
}
