import 'package:hive/hive.dart';
import '../../../../core/data/models/models.dart';
import '../../../../core/infraestructure/infrastructure.dart';
import 'datasource.dart';

class LocalItemsLotDatasource implements ILocalItemsLotDatasource {
  final Box box;
  final _lotKey = DatabaseConstants.transferLot.name;

  LocalItemsLotDatasource(this.box);

  // Helper to get the main map of all lots from the box
  Future<Map<String, dynamic>> _getAllLots() async {
    return Map<String, dynamic>.from(await box.get(_lotKey) ?? {});
  }

  // Helper to save the main map back to the box
  Future<void> _saveAllLots(Map<String, dynamic> allLots) async {
    await box.put(_lotKey, allLots);
  }

  @override
  Future<List<AdjustStockItemModel>> load(int enterpriseCode) async {
    final allLots = await _getAllLots();
    final enterpriseLotMap = allLots[enterpriseCode.toString()] as Map? ?? {};

    return enterpriseLotMap.values
        .map(
          (itemMap) =>
              AdjustStockItemModel.fromJson(Map<String, dynamic>.from(itemMap)),
        )
        .toList();
  }

  @override
  Future<void> addItem(AdjustStockItemModel item) async {
    final allLots = await _getAllLots();
    final enterpriseCodeStr = item.EnterpriseCode.toString();
    final productCodeStr = item.ProductPackingCode.toString();

    final enterpriseLotMap = Map<String, dynamic>.from(
      allLots[enterpriseCodeStr] ?? {},
    );
    enterpriseLotMap[productCodeStr] = item.toJson();
    allLots[enterpriseCodeStr] = enterpriseLotMap;

    await _saveAllLots(allLots);
  }

  @override
  Future<void> removeItem(AdjustStockItemModel item) async {
    final allLots = await _getAllLots();
    final enterpriseCodeStr = item.EnterpriseCode.toString();
    final productCodeStr = item.ProductPackingCode.toString();

    if (allLots.containsKey(enterpriseCodeStr)) {
      final enterpriseLotMap = Map<String, dynamic>.from(
        allLots[enterpriseCodeStr],
      );
      enterpriseLotMap.remove(productCodeStr);
      allLots[enterpriseCodeStr] = enterpriseLotMap;
      await _saveAllLots(allLots);
    }
  }

  @override
  Future<void> clear(int enterpriseCode) async {
    final allLots = await _getAllLots();
    allLots.remove(enterpriseCode.toString());
    await _saveAllLots(allLots);
  }
}
