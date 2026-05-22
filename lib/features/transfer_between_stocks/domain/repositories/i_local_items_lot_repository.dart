import 'package:celta_inventario/features/transfer_between_stocks/domain/entities/entities.dart';

abstract class ILocalItemsLotRepository {
  Future<void> addItem(ProductLotInfoEntity item);
  Future<void> removeItem({
    required int productPackingCode,
    required int enterpriseCode,
  });
  Future<List<ProductLotInfoEntity>> load(int enterpriseCode);
  Future<void> clear(int enterpriseCode);
}
