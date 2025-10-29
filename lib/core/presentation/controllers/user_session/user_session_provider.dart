import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/models.dart';
import '../../../providers/hive/hive.dart';
import '../../../providers/user_session/user_session.dart';

part 'user_session_provider.g.dart';

@Riverpod(keepAlive: true)
class UserSession extends _$UserSession {
  @override
  Future<UserSessionModel?> build() async {
    //dont need to use guard because the riverpor already treat this and return async error if throws
    return await ref.read(localUserSessionRepositoryProvider).get();
  }

  Future<void> saveSession(UserSessionModel value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(localUserSessionRepositoryProvider).save(value);
      return value;
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(localUserSessionRepositoryProvider).logout();
      ref.read(hiveBoxAppSettingsProvider).clear();
      ref.read(hiveBoxBuyRequestProvider).clear();
      ref.read(hiveBoxTransferBetweenStocksProvider).clear();
      return null;
    });
  }
}
