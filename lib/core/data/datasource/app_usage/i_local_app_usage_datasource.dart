import '../../models/models.dart';

abstract class ILocalAppUsageDatasource {
  Future<List<AppUsageModel>> load();
  Future<void> insert(List<AppUsageModel> data, int counter);
  Future<int> getCounter();
  Future<void> clear();
}
