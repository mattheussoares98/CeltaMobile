import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../providers.dart';

part 'auth_state_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthStateController extends _$AuthStateController {
  @override
  Future<UserEntity?> build() async {
    final authRepository = ref.watch(authRepositoryProvider);
    return await authRepository.getCurrentUser();
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).logout();
      ref.invalidate(userSessionProvider);
      return null;
    });
  }
}
