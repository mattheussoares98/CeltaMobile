import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/models.dart';
import 'user_session.dart';

part 'user_session_provider.g.dart';

@Riverpod(keepAlive: true)
class UserSession extends _$UserSession {
  @override
  Future<UserSessionModel?> build() async {
    //dont need to use guard because the riverpor already treat this and return async error if throws
    return await ref.read(localUserSessionDatasourceProvider).get();
  }

  Future<void> saveSession(UserSessionModel value) async {
    state = await AsyncValue.guard(() async {
      await ref.read(localUserSessionDatasourceProvider).save(value);
      return value;
    });
  }

  Future<void> clearSession() async {
    state = await AsyncValue.guard(() async {
      await ref.read(localUserSessionDatasourceProvider).clear();
      return null;
    });
  }
}
