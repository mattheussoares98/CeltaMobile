import 'package:hive/hive.dart';

import '../models/models.dart';
import 'datasource.dart';

class LocalPendingSaleRequestDatasource
    implements ILocalPendingSaleRequestDatasource {
  final Box hiveBox;
  LocalPendingSaleRequestDatasource(this.hiveBox);

  @override
  Future<PendingSaleRequestModel?> load(int enterpriseCode) async {
    final value = await hiveBox.get(enterpriseCode);
    if (value == null) {
      return null;
    }

    return PendingSaleRequestModel.fromJson(value);
  }

  @override
  Future<void> save(PendingSaleRequestModel value, int enterpriseCode) async {
    await hiveBox.put(enterpriseCode, value.toJson());
  }

  @override
  Future<void> clear() async {
    hiveBox.clear();
  }
}
