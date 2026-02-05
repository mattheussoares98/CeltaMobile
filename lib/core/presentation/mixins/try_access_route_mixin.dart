import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commom_widgets/commom_widgets.dart';
import '../../../features/enterprises/presentation/controllers/controllers.dart';
import '../../../localization/string_hardcoded.dart';
import '../../../routing/routing.dart';
import '../../domain/entities/entities.dart';
import '../controllers/enterprises/enterprises.dart';
import '../controllers/resource/resource.dart';
import '../controllers/user_session/user_session.dart';

mixin TryAccessRouteMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  void tryAccessRoute(
    Routes route,
    Modules module, {
    required bool? replace,
    Map<String, String>? pathParameters,
    Object? extra,
  }) async {
    final enterpriseName = ref.read(
      validatedUserSessionProvider.select((s) => s.value!.enterprise!.name),
    );
    final enabledModulesByEnterprise = await ref.read(
      enabledModulesByEnterpriseNameStateControllerProvider(
        enterpriseName,
      ).future,
    );
    final selectedEnterprise = ref.read(
      selectedEnterpriseStateControllerProvider,
    );

    final correspondentEnterprise = enabledModulesByEnterprise.firstWhereOrNull(
      (e) => e.cnpjNumber == selectedEnterprise?.CnpjNumber,
    );
    if (correspondentEnterprise == null) {
      _showDisabledModuleMessage(route);
      return;
    }

    final enabledModules = correspondentEnterprise.enabledModules;
    bool moduleIsEnabled = enabledModules.contains(module);
    if (!moduleIsEnabled) {
      _showDisabledModuleMessage(route);
      return;
    }

    if (module == Modules.adjustPrice) {
      final canAccess = await ref.read(
        canAccessResourceStateControllerProvider(
          BsRoutine.adjustSalePrice,
          BsResource.adjustSalePrice,
        ).future,
      );
      if (!canAccess) {
        _showUserWithoutPermissionMessage();
        return;
      }
    }

    if (replace == true) {
      context.goNamed(
        route.name,
        pathParameters: pathParameters ?? {},
        extra: extra,
      );
    } else {
      context.pushNamed(
        route.name,
        pathParameters: pathParameters ?? {},
        extra: extra,
      );
    }
  }

  void _showDisabledModuleMessage(Routes route) {
    showAlertDialog(
      context: context,
      title: 'Módulo desabilitado'.hardcoded,
      content:
          'O módulo ${route.module.toUpperCase()} está desabilitado para essa empresa. Caso queira habilitar, entre em contato com o setor administrativo'
              .hardcoded,
    );
  }

  void _showUserWithoutPermissionMessage() {
    showAlertDialog(
      context: context,
      title: 'Usuário sem permissão'.hardcoded,
      content: 'Seu usuário não possui permissão para alterar preços'.hardcoded,
    );
  }
}
