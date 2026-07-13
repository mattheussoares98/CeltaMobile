import 'package:celta_inventario/core/presentation/controllers/bs_version/bs_version.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_initialization_controller.g.dart';

@Riverpod(keepAlive: true)
class HomeInitializationController extends _$HomeInitializationController {
  @override
  FutureOr<void> build() async {
    final validatedUser = await ref.read(validatedUserSessionProvider.future);

    final enterpriseName = validatedUser?.enterprise?.name;

    if (enterpriseName == null) {
      throw Exception(
        'Nenhuma empresa selecionada. Carregue os dados novamente',
      );
    }

    await Future.wait([
      ref.read(enterprisesStateControllerProvider().future),
      ref.read(bsVersionStateControllerProvider.future),
      ref.read(
        enabledModulesByEnterpriseNameStateControllerProvider(
          enterpriseName,
        ).future,
      ),
    ]);
  }

  void refresh() {
    ref.invalidate(validatedUserSessionProvider);
    ref.invalidate(enterprisesStateControllerProvider);
    ref.invalidate(bsVersionStateControllerProvider);
    ref.invalidate(enabledModulesByEnterpriseNameStateControllerProvider);
    ref.invalidate(canAccessResourceStateControllerProvider);
    ref.invalidateSelf();
  }
}
