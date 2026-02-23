import '../../models/models.dart';

abstract class IRemoteAppUsageDatasource {
  Future<void> insert(List<AppUsageModel> model);
  Future<List<AppUsageModel>> load({
    required int enterpriseId,
    required DateTime startDate,
    required DateTime endDate,
  });
}
