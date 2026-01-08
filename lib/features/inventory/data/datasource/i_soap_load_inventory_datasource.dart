import '../models/models.dart';

abstract class ISoapLoadInventoryDatasource {
  Future<InventoryModel> load({
    required String urlInUse,
    required String crossIdentity,
    required int enterpriseCode,
  });
}
