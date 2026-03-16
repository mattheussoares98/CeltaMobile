import 'package:hive/hive.dart';

import '../models/models.dart';
import 'datasource.dart';

class LocalLastSavedSaleRequestDatasource
    implements ILocalLastSavedSaleRequestDatasource {
  final Box hiveBox;
  LocalLastSavedSaleRequestDatasource(this.hiveBox);

  static const String _keyPrefix = 'last_saved_sale_request_';

  @override
  Future<SoapLastSavedSaleRequestModel?> load(int enterpriseCode) async {
    final response = await hiveBox.get('$_keyPrefix$enterpriseCode');

    return response != null
        ? SoapLastSavedSaleRequestModel.fromJson(response)
        : null;
  }

  @override
  Future<void> save({
    required SoapLastSavedSaleRequestModel value,
    required int enterpriseCode,
  }) async {
    await hiveBox.put('$_keyPrefix$enterpriseCode', value.toJson());
  }
}
