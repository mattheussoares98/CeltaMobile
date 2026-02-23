import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/entities.dart';
import '../../../providers/app_usage/app_usage.dart';
import '../user_session/user_session.dart';

part 'app_usage_state_controller.g.dart';

@riverpod
class AppUsageStateController extends _$AppUsageStateController {
  @override
  FutureOr<List<AppUsageEntity>?> build() async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 20), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });
    return null;
  }

  Future<void> loadRemoteUsageReport({
    required DateTime start,
    required DateTime end,
    required int enterpriseId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(appUsageRepositoryProvider);
      return await repository.loadRemoteUsageReport(
        enterpriseId: enterpriseId,
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
