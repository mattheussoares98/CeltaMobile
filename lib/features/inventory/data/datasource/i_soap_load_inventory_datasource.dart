import '../models/models.dart';

abstract class ISoapLoadInventoryDatasource {
  Future<List<InventoryModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
  });
}
