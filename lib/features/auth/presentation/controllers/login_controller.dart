import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {}

  Future<void> login({
    required String enterpriseName,
    required String userName,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final authRepository = ref.read(authRepositoryProvider);

    state = await AsyncValue.guard(
      () => authRepository.login(
        enterpriseName: enterpriseName,
        password: password,
        userName: userName,
      ),
    );
  }
}
