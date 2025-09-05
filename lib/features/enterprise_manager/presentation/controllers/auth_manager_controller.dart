import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../exceptions/exceptions.dart';
import '../../providers.dart';

part 'auth_manager_controller.g.dart';

@riverpod
class AuthManagerController extends _$AuthManagerController with ErrorHandling {
  @override
  FutureOr<void> build() {}

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(authManagerRepositoryProvider);
      await repository.login(email, password);
    } catch (e, st) {
      state = getAsyncError(e, st);
    }
  }
}
