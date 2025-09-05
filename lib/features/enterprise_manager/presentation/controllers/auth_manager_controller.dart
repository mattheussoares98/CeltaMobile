import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers.dart';

part 'auth_manager_controller.g.dart';

@riverpod
class AuthManagerController extends _$AuthManagerController {
  @override
  FutureOr<void> build() {}

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authManagerRepositoryProvider);
    state = await AsyncValue.guard(() => repository.login(email, password));
  }
}
