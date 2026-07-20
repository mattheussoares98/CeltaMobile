import 'package:celta_inventario/core/data/datasource/app_usage/app_usage.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/app_usage/app_usage.dart';
import 'package:collection/collection.dart';

class AppUsageRepositoryImpl implements IAppUsageRepository {
  final IRemoteAppUsageDatasource remoteDs;
  final ILocalAppUsageDatasource localDs;

  AppUsageRepositoryImpl(this.remoteDs, this.localDs);

  @override
  Future<List<AppUsageEntity>> loadRemoteUsageReport(
    LoadAppUsageParams params,
  ) async {
    final data = await remoteDs.load(params);

    return data.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> addUsage(AppUsageEntity entity) async {
    final localData = await localDs.load();

    final equalRequest = localData.firstWhereOrNull(
      (e) =>
          e.userName == entity.userName &&
          e.usageType?.name == entity.usageType?.name &&
          e.enterpriseId == entity.enterpriseId,
    );

    late List<AppUsageModel> newData;

    if (equalRequest == null) {
      newData = [...localData, AppUsageModel.fromEntity(entity)];

      await localDs.insert(newData);
    } else {
      final updatedRequest = entity.copyWith(
        requestCount: equalRequest.requestCount + 1,
      );

      newData = localData.where((e) => e != equalRequest).toList()
        ..add(AppUsageModel.fromEntity(updatedRequest));

      await localDs.insert(newData);
    }

    final lastUpdatedDate = await localDs.getLastUpdatedDate();
    final now = DateTime.now();
    if (lastUpdatedDate?.year != now.year ||
        lastUpdatedDate?.month != now.month ||
        lastUpdatedDate?.day != now.day) {
      await Future.wait([
        remoteDs.insert(newData),
        localDs.clearData(),
        localDs.updateLastUploadDate(),
      ]);
    }
  }

  @override
  Future<List<GroupedUsageEntity>> loadGroupedUsageReport(
    LoadAppUsageParams params,
  ) async {
    final data = await remoteDs.loadGroupedByEnterprise(params);

    return data.map((e) => e.toEntity()).toList();
  }
}
