import 'package:celta_inventario/core/data/models/app_usage/app_usage_model.dart';
import 'package:hive/hive.dart';

import 'package:celta_inventario/core/data/datasource/app_usage/app_usage.dart';

class LocalAppUsageDatasource implements ILocalAppUsageDatasource {
  final Box hiveBox;
  LocalAppUsageDatasource(this.hiveBox);

  static const _dataKey = 'app_usage';
  static const _lastUpdatedDateKey = 'last_updated_date';

  @override
  Future<void> insert(List<AppUsageModel> data) async {
    return hiveBox.put(_dataKey, data.map((e) => e.toJson()).toList());
  }

  @override
  Future<List<AppUsageModel>> load() async {
    final localData = await hiveBox.get(_dataKey) as List? ?? [];

    return localData.map((e) => AppUsageModel.fromJson(e)).toList();
  }

  @override
  Future<void> clearData() async {
    await hiveBox.delete(_dataKey);
  }

  @override
  Future<DateTime?> getLastUpdatedDate() async {
    final value = await hiveBox.get(_lastUpdatedDateKey);
    return DateTime.tryParse(value as String? ?? '');
  }

  @override
  Future<void> updateLastUploadDate() async {
    hiveBox.put(_lastUpdatedDateKey, DateTime.now().toIso8601String());
  }
}
