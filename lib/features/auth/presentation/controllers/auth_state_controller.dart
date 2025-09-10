import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../providers.dart';

part 'auth_state_controller.g.dart';

@riverpod
class AuthStateController extends _$AuthStateController {
  @override
  Future<UserEntity?> build() async {
    final authRepository = ref.watch(authRepositoryProvider);
    return authRepository.getCurrentUser();
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).logout();
      return null;
    });
  }
}
