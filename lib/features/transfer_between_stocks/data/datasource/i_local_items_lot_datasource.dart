import 'package:celta_inventario/features/transfer_between_stocks/data/models/models.dart';

abstract class ILocalItemsLotDatasource {
  Future<void> addItem(ProductLotInfoModel item);
  Future<void> removeItem({
    required int productPackingCode,
    required int enterpriseCode,
  });
  Future<List<ProductLotInfoModel>> load(int enterpriseCode);
  Future<void> clear(int enterpriseCode);
}
