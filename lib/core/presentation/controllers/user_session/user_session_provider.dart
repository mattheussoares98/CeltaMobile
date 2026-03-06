import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers/hive/hive.dart';
import '../../../providers/notification/notification.dart';
import '../../../providers/user_session/user_session.dart';
import '../app_version/app_version.dart';

part 'user_session_provider.g.dart';

DeviceType get deviceType {
  if (kIsWeb) return DeviceType.web;

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return DeviceType.android;
    case TargetPlatform.iOS:
      return DeviceType.ios;
    case TargetPlatform.windows:
      return DeviceType.windows;
    case TargetPlatform.macOS:
      return DeviceType.macOS;
    default:
      return DeviceType.web;
  }
}

@Riverpod(keepAlive: true)
class UserSession extends _$UserSession {
  @override
  Future<UserSessionModel?> build() async {
    //dont need to use guard because the riverpor already treat this and return async error if throws

    final localSession = await ref.watch(userSessionRepositoryProvider).get();

    if (localSession != null) {
      _syncSupabaseSession(localSession);
      return localSession;
    }
    return null;
  }

  Future<void> saveSession(UserSessionModel value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(userSessionRepositoryProvider).save(value);
      _syncSupabaseSession(value);
      return value;
    });
  }

  Future<void> logout(DeviceType deviceType) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userName = state.value!.user.name!;
      final enterpriseId = state.value!.enterprise!.id!;
      await ref
          .read(userSessionRepositoryProvider)
          .logout(
            userName: userName,
            deviceType: deviceType,
            enterpriseId: enterpriseId,
          );

      final boxesToClear = ref.read(boxesToClearOnLogoutProvider);
      for (final box in boxesToClear) {
        box.clear();
      }
      return null;
    });
  }

  Future<void> _syncSupabaseSession(UserSessionModel session) async {
    try {
      // 1. Get the latest FCM token from the dedicated datasource
      final fcmToken = await ref
          .read(notificationDatasourceProvider)
          .getToken();

      final appVersion = await ref.read(
        appVersionStateControllerProvider.future,
      );

      // 3. Call the RPC to upsert the session record
      await ref
          .read(supabaseUserSessionDatasourceProvider)
          .handleUserSession(
            firebaseEnterpriseId: session.enterprise!.id!,
            userName: session.user.name!,
            deviceType: deviceType,
            fcmToken: fcmToken,
            appVersion: appVersion,
          );

      debugPrint('Sync: Remote session updated successfully');
    } catch (e) {
      // PERFORMANCE: We log the error but don't rethrow, as a failed
      // analytics/session sync shouldn't crash the user's app experience.
      debugPrint('Sync Error: Background session sync failed [Trace:');
    }
  }
}
