import 'package:hive/hive.dart';

import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';

class LocalSaleRequestDatasource implements ILocalSaleRequestDatasource {
  final Box hiveBox;
  LocalSaleRequestDatasource(this.hiveBox);

  static const String _keyPrefix = 'pending_sale_request_';

  @override
  Future<SoapSaleRequestModel?> load(int enterpriseCode) async {
    final value = await hiveBox.get('$_keyPrefix$enterpriseCode');
    if (value == null) {
      return null;
    }

    return SoapSaleRequestModel.fromJson(value);
  }

  @override
  Future<void> save(SoapSaleRequestModel value, int enterpriseCode) async {
    await hiveBox.put('$_keyPrefix$enterpriseCode', value.toJson());
  }

  @override
  Future<void> clear(int enterpriseCode) async {
    await hiveBox.delete('$_keyPrefix$enterpriseCode');
  }
}
