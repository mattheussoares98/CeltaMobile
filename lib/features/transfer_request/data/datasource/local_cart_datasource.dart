import 'package:hive/hive.dart';

import 'package:celta_inventario/core/infraestructure/infrastructure.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/data/models/models.dart';
import 'package:celta_inventario/features/transfer_request/data/datasource/datasource.dart';

class LocalCartDatasource implements ILocalCartDatasource {
  final Box box;
  static final _draftsKey = DatabaseConstants.transferRequest.name;

  LocalCartDatasource(this.box);

  // Helper to get the main map of all drafts
  Future<Map<String, dynamic>> _getAllDrafts() async {
    return Map<String, dynamic>.from(await box.get(_draftsKey) ?? {});
  }

  // Helper to save the main map back
  Future<void> _saveAllDrafts(Map<String, dynamic> allDrafts) async {
    return await box.put(_draftsKey, allDrafts);
  }

  @override
  Future<List<TransferRequestProductItemModel>> load(DraftKey key) async {
    final allDrafts = await _getAllDrafts();
    final draftMap = allDrafts[key.toMapKey()] as Map? ?? {};

    return draftMap.values
        .map(
          (itemMap) => TransferRequestProductItemModel.fromJson(
            Map<String, dynamic>.from(itemMap),
          ),
        )
        .toList();
  }

  @override
  Future<void> addItem(
    DraftKey key,
    TransferRequestProductItemModel item,
  ) async {
    final allDrafts = await _getAllDrafts();
    final draftKey = key.toMapKey();

    // Get the map for this specific draft
    final draftMap = Map<String, dynamic>.from(allDrafts[draftKey] ?? {});

    // Add or update the product in that draft
    draftMap[item.product.ProductPackingCode.toString()] = item.toJson();

    // Put the draft back into the main map
    allDrafts[draftKey] = draftMap;

    await _saveAllDrafts(allDrafts);
  }

  @override
  Future<void> removeItem(
    DraftKey key,
    TransferRequestProductItemModel item,
  ) async {
    final allDrafts = await _getAllDrafts();
    final draftKey = key.toMapKey();
    final productKey = item.product.ProductPackingCode.toString();

    if (allDrafts.containsKey(draftKey)) {
      final draftMap = Map<String, dynamic>.from(allDrafts[draftKey]);
      draftMap.remove(productKey);
      allDrafts[draftKey] = draftMap;
      await _saveAllDrafts(allDrafts);
    }
  }

  @override
  Future<void> clear(DraftKey key) async {
    final allDrafts = await _getAllDrafts();
    allDrafts.remove(key.toMapKey());
    await _saveAllDrafts(allDrafts);
  }
}
