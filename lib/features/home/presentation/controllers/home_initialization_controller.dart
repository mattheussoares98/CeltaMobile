import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/bs_version/bs_version.dart';
import '../../../../core/presentation/controllers/enterprises/enterprises.dart';
import '../../../../core/presentation/controllers/resource/resource.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';

part 'home_initialization_controller.g.dart';

@Riverpod(keepAlive: true)
class HomeInitializationController extends _$HomeInitializationController {
  @override
  FutureOr<void> build() async {
    final enterpriseName = ref.watch(
      userSessionProvider.select((s) => s.value?.enterprise?.name),
    );

    if (enterpriseName == null) {
      throw Exception(
        'Nenhuma empresa selecionada. Carregue os dados novamente',
      );
    }

    await Future.wait([
      ref.watch(enterprisesStateControllerProvider().future),
      ref.watch(bsVersionStateControllerProvider.future),
      ref.watch(
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
