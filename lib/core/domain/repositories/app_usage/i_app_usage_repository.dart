import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IAppUsageRepository {
  Future<void> addUsage(AppUsageEntity entity);
  Future<List<AppUsageEntity>> loadRemoteUsageReport({
    required int? enterpriseId,
    required DateTime start,
    required DateTime end,
  });
  Future<List<GroupedUsageEntity>> loadGroupedUsageReport({
    required int? enterpriseId,
    required DateTime start,
    required DateTime end,
  });
}
