import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers/hive/hive.dart';
import '../../../providers/user_session/user_session.dart';

part 'user_session_provider.g.dart';

@Riverpod(keepAlive: true)
class UserSession extends _$UserSession {
  @override
  Future<UserSessionModel?> build() async {
    //dont need to use guard because the riverpor already treat this and return async error if throws
    return await ref.watch(userSessionRepositoryProvider).get();
  }

  Future<void> saveSession(UserSessionModel value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(userSessionRepositoryProvider).save(value);
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
}
