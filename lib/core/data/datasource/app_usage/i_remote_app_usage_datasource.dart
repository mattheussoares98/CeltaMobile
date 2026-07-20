import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IRemoteAppUsageDatasource {
  Future<void> insert(List<AppUsageModel> model);
  Future<List<AppUsageModel>> load(LoadAppUsageParams params);
  Future<List<GroupedUsageModel>> loadGroupedByEnterprise(
    LoadAppUsageParams params,
  );
}
