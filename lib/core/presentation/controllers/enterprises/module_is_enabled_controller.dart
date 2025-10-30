import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/entities.dart';
import '../user_session/user_session.dart';
import 'enterprises.dart';

part 'module_is_enabled_controller.g.dart';

@riverpod
class ModuleIsEnabledController extends _$ModuleIsEnabledController {
  @override
  Future<bool> build(Modules module, String cnpjNumber) async {
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    final enabledModules = await ref.read(
      enabledModulesByEnterpriseNameStateControllerProvider(
        userSession!.enterprise!.name,
      ).future,
    );

    final enterpriseIndex = enabledModules.indexWhere(
      (e) => e.cnpjNumber == cnpjNumber,
    );

    if (enterpriseIndex == -1) {
      return false;
    }

    return enabledModules[enterpriseIndex].enabledModules.contains(module);
  }
}
