import 'package:collection/collection.dart';

import '../../../data/datasource/app_usage/app_usage.dart';
import '../../../data/models/models.dart';
import '../../entities/entities.dart';
import 'app_usage.dart';

class AppUsageRepositoryImpl implements IAppUsageRepository {
  final IRemoteAppUsageDatasource remoteDs;
  final ILocalAppUsageDatasource localDs;

  AppUsageRepositoryImpl(this.remoteDs, this.localDs);

  @override
  Future<List<AppUsageEntity>> loadRemoteUsageReport({
    required int? enterpriseId,
    required DateTime start,
    required DateTime end,
  }) async {
    final data = await remoteDs.load(
      enterpriseId: enterpriseId,
      startDate: start,
      endDate: end,
    );

    return data.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> addUsage(AppUsageEntity entity) async {
    final localData = await localDs.load();
    final counter = await localDs.getCounter();

    final newCounter = counter + 1;

    final equalRequest = localData.firstWhereOrNull(
      (e) =>
          e.userName == entity.userName &&
          e.usageType.name == entity.usageType.name &&
          e.enterpriseId == entity.enterpriseId,
    );

    late List<AppUsageModel> newData;

    if (equalRequest == null) {
      newData = [...localData, AppUsageModel.fromEntity(entity)];

      await localDs.insert(newData, newCounter);
    } else {
      final updatedRequest = entity.copyWith(
        requestCount: equalRequest.requestCount + 1,
      );

      newData = localData.where((e) => e != equalRequest).toList()
        ..add(AppUsageModel.fromEntity(updatedRequest));

      await localDs.insert(newData, newCounter);
    }

    if (newCounter >= 5) {
      await remoteDs.insert(newData);
      await localDs.clear();
    }
  }
}
