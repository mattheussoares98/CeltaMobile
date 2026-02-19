import '../../models/models.dart';

abstract class ISupabaseAppUsageDatasource {
  Future<void> insert(List<AppUsageModel> model);
  Future<List<AppUsageModel>> load({
    required int enterpriseId,
    required DateTime startDate,
    required DateTime endDate,
  });
}
