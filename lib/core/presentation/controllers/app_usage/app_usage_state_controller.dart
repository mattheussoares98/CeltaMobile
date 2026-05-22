import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';

part 'app_usage_state_controller.g.dart';

@Riverpod(keepAlive: true)
class AppUsageStateController extends _$AppUsageStateController {
  @override
  FutureOr<List<AppUsageEntity>?> build() => null;

  Future<void> loadRemoteUsageReport({
    required DateTime start,
    required DateTime end,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(appUsageRepositoryProvider);
      return await repository.loadRemoteUsageReport(
        enterpriseId: null, //load from all enterprises if it is null
        start: start,
        end: end,
      );
    });
  }

  Future<void> addUsage(UsageType usageType) async {
    try {
      final userName = await ref.read(
        userSessionProvider.selectAsync((s) => s?.user.name),
      );
      final enterpriseId = await ref.read(
        userSessionProvider.selectAsync((s) => s?.enterprise?.id),
      );
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
