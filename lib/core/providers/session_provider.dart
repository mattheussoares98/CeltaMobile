import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/models.dart';
import 'providers.dart';

part 'session_provider.g.dart';

@Riverpod(keepAlive: true)
class Session extends _$Session {
  @override
  Future<SessionModel?> build() async {
    //dont need to use guard because the riverpor already treat this and return async error if throws
    return await ref.read(localSessionDataSourceProvider).get();
  }

  Future<void> saveSession(SessionModel value) async {
    state = await AsyncValue.guard(() async {
      await ref.read(localSessionDataSourceProvider).save(value);
      return value;
    });
  }

  Future<void> clearSession() async {
    state = await AsyncValue.guard(() async {
      await ref.read(localSessionDataSourceProvider).clear();
      return null;
    });
  }
}
