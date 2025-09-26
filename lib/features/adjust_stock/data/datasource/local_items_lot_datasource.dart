import 'package:hive/hive.dart';
import '../../../../core/data/models/models.dart';
import 'datasource.dart';

class LocalItemsLotDatasource implements ILocalItemsLotDatasource {
  //unique Box for this feature
  final Box box;

  LocalItemsLotDatasource(this.box);

  @override
  Future<void> addItem(AdjustStockItemModel item) async {
    // THE FIX: Use a unique product identifier as the key.
    // Hive's .put() method automatically handles both INSERT and UPDATE.
    // If the key exists, it's updated. If not, it's created
    await box.put(item.ProductCode, item.toJson());
  }

  @override
  Future<void> removeItem(AdjustStockItemModel item) async {
    await box.delete(item.ProductCode);
  }

  @override
  Future<List<AdjustStockItemModel>> load() async {
    return box.values
        .map((e) => AdjustStockItemModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }
}
