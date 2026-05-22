import 'package:celta_inventario/features/inventory/data/models/models.dart';

abstract class ISoapLoadInventoryDatasource {
  Future<InventoryModel> load({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
  });
}
