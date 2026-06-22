import 'package:hive/hive.dart';

import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';

class LocalBSFSaleRequestDraftDatasource implements ILocalBSFSaleRequestDraftDatasource {
  final Box hiveBox;
  LocalBSFSaleRequestDraftDatasource(this.hiveBox);

  static const String _keyPrefix = 'bsf_draft_';

  String _getKey(int enterpriseCode, int requestTypeCode) {
    return '$_keyPrefix${enterpriseCode}_$requestTypeCode';
  }

  @override
  Future<void> save(
    BSFSaleRequestModel value, {
    required int enterpriseCode,
    required int requestTypeCode,
  }) async {
    await hiveBox.put(_getKey(enterpriseCode, requestTypeCode), value.toJson());
  }

  @override
  Future<BSFSaleRequestModel?> load({
    required int enterpriseCode,
    required int requestTypeCode,
  }) async {
    final value = await hiveBox.get(_getKey(enterpriseCode, requestTypeCode));
    if (value == null) {
      return null;
    }

    return BSFSaleRequestModel.fromJson(Map<String, dynamic>.from(value));
  }

  @override
  Future<void> clear({
    required int enterpriseCode,
    required int requestTypeCode,
  }) async {
    await hiveBox.delete(_getKey(enterpriseCode, requestTypeCode));
  }
}
