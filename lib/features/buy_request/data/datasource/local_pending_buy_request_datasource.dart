import 'package:hive/hive.dart';

import '../../../../core/infraestructure/infrastructure.dart';
import '../models/models.dart';
import 'datasource.dart';

class LocalPendingBuyRequestDatasource
    implements ILocalPendingBuyRequestDatasource {
  final Box box;
  LocalPendingBuyRequestDatasource(this.box);

  Future<Map<int, PendingBuyRequestModel>> _loadAll() async {
    final value = await box.get(DatabaseConstants.buyRequest.name);
    if (value == null) {
      return {};
    }

    return (value as Map).map(
      (key, value) => MapEntry(key, PendingBuyRequestModel.fromJson(value)),
    );
  }

  @override
  Future<void> update(PendingBuyRequestModel model, int enterpriseCode) async {
    final all = await _loadAll();
    final allJson = all.map((key, value) => MapEntry(key, value.toJson()));
    allJson[enterpriseCode] = model.toJson();
    //!Use by enterpriseCode because of the requests. The enterprise can be linked or not with the request
    await box.put(DatabaseConstants.buyRequest.name, allJson);
  }

  @override
  Future<PendingBuyRequestModel?> load(int enterpriseCode) async {
    final all = await _loadAll();
    final value = all[enterpriseCode];
    if (value == null) {
      return null;
    }

    return value;
  }
}
