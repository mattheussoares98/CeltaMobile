import '../models/models.dart';

abstract class ISoapLoadInventoryDatasource {
  Future<InventoryModel> load({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
  });
}
