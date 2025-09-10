import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../providers.dart';

part 'auth_manager_controller.g.dart';

@riverpod
class AuthManagerController extends _$AuthManagerController {
  @override
  FutureOr<void> build() {}

  Future<AuthResponse?> login(String email, String password) async {
    state = const AsyncValue.loading();

    AuthResponse? authResponse;

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authManagerRepositoryProvider);

      authResponse = await repository.login(email, password);
    });

    return authResponse;
  }
}
