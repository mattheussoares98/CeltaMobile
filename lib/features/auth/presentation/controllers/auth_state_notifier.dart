import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../providers.dart';

part 'auth_state_notifier.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  Future<UserEntity?> build() async {
    final authRepository = ref.watch(authRepositoryProvider);

    return await authRepository.getCurrentUser();
  }

  Future<void> logout() async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.logout();
    state = const AsyncValue.data(null);
  }
}
