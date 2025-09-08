import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../../../exceptions/exceptions.dart';
import '../../providers.dart';

part 'auth_state_controller.g.dart';

@riverpod
class AuthStateController extends _$AuthStateController with ErrorHandling {
  @override
  Future<UserEntity?> build() async {
    final authRepository = ref.watch(authRepositoryProvider);
    return authRepository.getCurrentUser();
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.logout();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = getAsyncError(e, st);
    }
  }
}
