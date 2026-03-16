import 'package:hive/hive.dart';

import '../models/models.dart';
import 'datasource.dart';

class LocalPendingSaleRequestDatasource
    implements ILocalPendingSaleRequestDatasource {
  final Box hiveBox;
  LocalPendingSaleRequestDatasource(this.hiveBox);

  static const String _keyPrefix = 'pending_sale_request_';

  @override
  Future<SoapPendingSaleRequestModel?> load(int enterpriseCode) async {
    final value = await hiveBox.get('$_keyPrefix$enterpriseCode');
    if (value == null) {
      return null;
    }

    return SoapPendingSaleRequestModel.fromJson(value);
  }

  @override
  Future<void> save(
    SoapPendingSaleRequestModel value,
    int enterpriseCode,
  ) async {
    await hiveBox.put('$_keyPrefix$enterpriseCode', value.toJson());
  }

  @override
  Future<void> clear(int enterpriseCode) async {
    await hiveBox.delete('$_keyPrefix$enterpriseCode');
  }
}
