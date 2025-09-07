import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../exceptions/exceptions.dart';
import '../../providers.dart';

part 'auth_manager_controller.g.dart';

@riverpod
class AuthManagerController extends _$AuthManagerController with ErrorHandling {
  @override
  FutureOr<void> build() {}

  Future<AuthResponse?> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(authManagerRepositoryProvider);
      final authResponse = await repository.login(email, password);
      state = const AsyncValue.data(null);
      return authResponse;
    } catch (e, st) {
      state = getAsyncError(e, st);
    }
    return null;
  }
}
