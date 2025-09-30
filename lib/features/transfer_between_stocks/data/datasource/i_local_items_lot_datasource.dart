import '../models/models.dart';

abstract class ILocalItemsLotDatasource {
  Future<void> addItem(ProductLotInfoModel item);
  Future<void> removeItem(ProductLotInfoModel item);
  Future<List<ProductLotInfoModel>> load(int enterpriseCode);
  Future<void> clear(int enterpriseCode);
}
