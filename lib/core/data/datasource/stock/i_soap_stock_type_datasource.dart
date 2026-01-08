import '../../models/models.dart';

abstract class ISoapStockTypeDatasource {
  Future<List<StockTypeModel>> load({
    required String workingUrl,
    required String crossIdentity,
  });
}
