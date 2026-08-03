import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/app_usage/app_usage.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_usage_state_controller.g.dart';

@Riverpod(keepAlive: true)
class AppUsageStateController extends _$AppUsageStateController {
  @override
  FutureOr<List<GroupedUsageEntity>?> build() {
    ref.cache(60);
    return null;
  }

  Future<void> loadRemoteUsageReport(DateTime date) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(appUsageRepositoryProvider);
      return await repository.loadGroupedUsageReport(
        LoadAppUsageParams(
          enterpriseId: null, //load from all enterprises if it is null
          startDate: date, //considering only month and year
          endDate: date,
        ), //considering only month and year
      );
    });
  }

  Future<void> addUsage(UsageType usageType) async {
    try {
      final userSession = await ref.read(userSessionProvider.future);
      final userName = userSession?.user.name;
      final enterpriseId = userSession?.enterprise?.id;
      final repository = ref.read(appUsageRepositoryProvider);

      if (userName == null || enterpriseId == null) return;

      await repository.addUsage(
        AppUsageEntity(
          userName: userName,
          enterpriseId: enterpriseId,
          usageType: usageType,
          requestCount: 1,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
