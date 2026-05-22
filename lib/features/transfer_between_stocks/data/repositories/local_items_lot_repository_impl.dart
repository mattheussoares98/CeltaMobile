import 'package:celta_inventario/features/transfer_between_stocks/data/datasource/datasource.dart';
import 'package:celta_inventario/features/transfer_between_stocks/data/models/models.dart';
import 'package:celta_inventario/features/transfer_between_stocks/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_between_stocks/domain/repositories/repositories.dart';

class LocalItemsLotRepositoryImpl implements ILocalItemsLotRepository {
  final ILocalItemsLotDatasource datasource;
  LocalItemsLotRepositoryImpl(this.datasource);

  @override
  Future<void> addItem(ProductLotInfoEntity item) async {
    await datasource.addItem(ProductLotInfoModel.fromEntity(item));
  }

  @override
  Future<void> clear(int enterpriseCode) async {
    await datasource.clear(enterpriseCode);
  }

  @override
  Future<List<ProductLotInfoEntity>> load(int enterpriseCode) async {
    final items = await datasource.load(enterpriseCode);
    return items.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> removeItem({
    required int productPackingCode,
    required int enterpriseCode,
  }) async {
    await datasource.removeItem(
      productPackingCode: productPackingCode,
      enterpriseCode: enterpriseCode,
    );
  }
}
