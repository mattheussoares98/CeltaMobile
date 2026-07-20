import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IAppUsageRepository {
  Future<void> addUsage(AppUsageEntity entity);
  Future<List<AppUsageEntity>> loadRemoteUsageReport(LoadAppUsageParams params);
  Future<List<GroupedUsageEntity>> loadGroupedUsageReport(
    LoadAppUsageParams params,
  );
}
