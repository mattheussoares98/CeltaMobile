import '../entities/entities.dart';

abstract class ILocalItemsLotRepository {
  Future<void> addItem(ProductLotInfoEntity item);
  Future<void> removeItem(ProductLotInfoEntity item);
  Future<List<ProductLotInfoEntity>> load(int enterpriseCode);
  Future<void> clear(int enterpriseCode);
}
