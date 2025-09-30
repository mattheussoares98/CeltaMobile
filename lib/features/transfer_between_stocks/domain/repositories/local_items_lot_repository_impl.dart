import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repositories.dart';

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
  Future<void> removeItem(ProductLotInfoEntity item) async {
    await datasource.removeItem(ProductLotInfoModel.fromEntity(item));
  }
}
