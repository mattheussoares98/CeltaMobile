import 'package:hive/hive.dart';

import '../models/models.dart';
import 'datasource.dart';

class LocalLastSavedSaleRequestDatasource
    implements ILocalLastSavedSaleRequestDatasource {
  final Box hiveBox;
  LocalLastSavedSaleRequestDatasource(this.hiveBox);

  @override
  Future<LastSavedSaleRequestModel?> load(int enterpriseCode) async {
    final response = await hiveBox.get(enterpriseCode);

    return response != null
        ? LastSavedSaleRequestModel.fromJson(response)
        : null;
  }

  @override
  Future<void> save({
    required LastSavedSaleRequestModel value,
    required int enterpriseCode,
  }) async {
    await hiveBox.put(enterpriseCode, value.toJson());
  }
}
