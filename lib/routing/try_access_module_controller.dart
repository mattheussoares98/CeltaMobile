import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../commom_widgets/commom_widgets.dart';
import '../core/domain/entities/entities.dart';
import '../core/presentation/controllers/bs_version/bs_version.dart';
import '../core/presentation/controllers/enterprises/enterprises.dart';
import '../core/presentation/controllers/resource/resource.dart';
import '../core/presentation/controllers/user_session/user_session.dart';
import '../core/presentation/helpers/helpers.dart';
import '../features/enterprises/presentation/controllers/controllers.dart';
import '../localization/string_hardcoded.dart';
import 'routing.dart';

part 'try_access_module_controller.g.dart';

@riverpod
class TryAccessModuleController extends _$TryAccessModuleController {
  @override
  FutureOr<void> build() {}

  Future<void> tryAccess({
    required BuildContext context,
    required Routes route,
    required int? enterpriseCode,
    required Modules module,
    bool replace = false,
    Map<String, String>? pathParameters,
    Object? extra,
  }) async {
    final minimumBsVersionDate = switch (route) {
      Routes.searchSaleRequests => DateTime(2026, 3, 18),
      _ => null,
    };

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (minimumBsVersionDate != null) {
        final bsVersionDate = await ref.read(
          bsVersionStateControllerProvider.future,
        );

        if (bsVersionDate?.isBefore(minimumBsVersionDate) ?? false) {
          showAlertDialog(
            context: context,
            title: 'Atualize o BS'.hardcoded,
            content:
                'A versão do BS precisa ser atualizada para utilizar essa funcionalidade'
                    .hardcoded,
          );
          return;
        }
      }

      final router = GoRouter.of(context);
      final String? currentRouteName =
          router.routerDelegate.currentConfiguration.last.route.name;

      if (currentRouteName == route.name) {
        debugPrint('Navigation Cancelled: User already on ${route.name}');
        return;
      }

      final enterpriseName = ref.read(
        validatedUserSessionProvider.select((s) => s.value!.enterprise!.name),
      );
      final enabledModulesByEnterprise = await ref.read(
        enabledModulesByEnterpriseNameStateControllerProvider(
          enterpriseName,
        ).future,
      );

      final enabledModulesBySelectedEnterprise = enabledModulesByEnterprise
          .firstWhereOrNull((e) {
            if (enterpriseCode == null) {
              return e.idFromErp ==
                  ref.read(
                    selectedEnterpriseStateControllerProvider.select(
                      (s) => s?.Code,
                    ),
                  );
            }

            return e.idFromErp == enterpriseCode;
          });

      final moduleIsFree =
          module == Modules.stockReplacement &&
          ModuleIsFreeUntil.stockReplacementIsFree;

      if (!moduleIsFree &&
          (enabledModulesBySelectedEnterprise == null ||
              !enabledModulesBySelectedEnterprise.enabledModules.contains(
                module,
              ))) {
        _showDisabledModuleMessage(context, module);
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
          _showUserWithoutPermissionMessage(context);
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
    });
  }
}

void _showDisabledModuleMessage(BuildContext context, Modules module) {
  showAlertDialog(
    context: context,
    title: 'Módulo desabilitado'.hardcoded,
    content:
        'O módulo ${module.description.toUpperCase()} está desabilitado para essa empresa...'
            .hardcoded,
  );
}

void _showUserWithoutPermissionMessage(BuildContext context) {
  showAlertDialog(
    context: context,
    title: 'Usuário sem permissão'.hardcoded,
    content: 'Seu usuário não possui permissão para alterar preços'.hardcoded,
  );
}
