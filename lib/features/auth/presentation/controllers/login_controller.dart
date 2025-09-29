import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/products/products.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
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

    state = await AsyncValue.guard(() async {
      await ref
          .read(authRepositoryProvider)
          .login(
            enterpriseName: enterpriseName,
            password: password,
            userName: userName,
          );
      ref.invalidate(userSessionProvider);
      ref.invalidate(validatedUserSessionProvider);
      ref.invalidate(searchProductsStateControllerProvider);
    });
  }
}
