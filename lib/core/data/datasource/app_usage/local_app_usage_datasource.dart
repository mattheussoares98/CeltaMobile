import 'package:celta_inventario/core/data/models/app_usage/app_usage_model.dart';
import 'package:hive/hive.dart';

import 'app_usage.dart';

class LocalAppUsageDatasource implements ILocalAppUsageDatasource {
  final Box hiveBox;
  LocalAppUsageDatasource(this.hiveBox);

  static const _dataKey = 'app_usage';
  static const _counterKey = 'usage_counter';

  @override
  Future<void> insert(List<AppUsageModel> data, int counter) async {
    await Future.wait([
      hiveBox.put(_dataKey, data.map((e) => e.toJson()).toList()),
      hiveBox.put(_counterKey, counter),
    ]);
  }

  @override
  Future<List<AppUsageModel>> load() async {
    final localData = await hiveBox.get(_dataKey) as List? ?? [];

    return localData.map((e) => AppUsageModel.fromJson(e)).toList();
  }

  @override
  Future<void> clear() async {
    await hiveBox.clear();
  }

  @override
  Future<int> getCounter() async => await hiveBox.get(_counterKey) as int? ?? 0;
}
