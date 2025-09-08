import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../exceptions/error_handilng.dart';
import '../../providers.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController with ErrorHandling {
  @override
  FutureOr<void> build() {}

  Future<void> login({
    required String enterpriseName,
    required String userName,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    try {
      final authRepository = ref.read(authRepositoryProvider);

      await authRepository.login(
        enterpriseName: enterpriseName,
        password: password,
        userName: userName,
      );

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = getAsyncError(e, st);
    }
  }
}
