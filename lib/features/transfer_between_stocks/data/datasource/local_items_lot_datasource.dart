import 'package:hive/hive.dart';
import '../../../../core/infraestructure/infrastructure.dart';
import '../models/models.dart';
import 'datasource.dart';

class LocalItemsLotDatasource implements ILocalItemsLotDatasource {
  final Box box;
  final _lotKey = DatabaseConstants.transferBetweenStocks.name;

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
  Future<List<ProductLotInfoModel>> load(int enterpriseCode) async {
    final allLots = await _getAllLots();
    final enterpriseLotMap = allLots[enterpriseCode.toString()] as Map? ?? {};

    return enterpriseLotMap.values
        .map((itemMap) => ProductLotInfoModel.fromJson(itemMap))
        .toList();
  }

  @override
  Future<void> addItem(ProductLotInfoModel item) async {
    final allLots = await _getAllLots();
    final enterpriseCodeStr = item.product.EnterpriseCode.toString();
    final productCodeStr = item.product.ProductPackingCode.toString();

    final enterpriseLotMap = Map<String, dynamic>.from(
      allLots[enterpriseCodeStr] ?? {},
    );
    enterpriseLotMap[productCodeStr] = item.toJson();
    allLots[enterpriseCodeStr] = enterpriseLotMap;

    await _saveAllLots(allLots);
  }

  @override
  Future<void> removeItem({
    required int productPackingCode,
    required int enterpriseCode,
  }) async {
    final allLots = await _getAllLots();
    final enterpriseCodeStr = enterpriseCode.toString();
    final productCodeStr = productPackingCode.toString();

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
