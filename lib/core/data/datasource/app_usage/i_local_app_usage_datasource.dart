import '../../models/models.dart';

abstract class ILocalAppUsageDatasource {
  Future<List<AppUsageModel>> load();
  Future<void> insert(List<AppUsageModel> data);
  Future<DateTime?> getLastUpdatedDate();
  Future<void> updateLastUploadDate();
  Future<void> clearData();
}
