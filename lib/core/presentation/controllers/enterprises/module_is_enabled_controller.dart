import 'dart:async';

import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';

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

    return enabledModules
            .firstWhereOrNull((e) => e.cnpjNumber == cnpjNumber)
            ?.enabledModules
            .contains(module) ??
        false;
  }
}
