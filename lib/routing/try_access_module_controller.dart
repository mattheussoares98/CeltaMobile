import 'dart:developer' as dev;

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/bs_version/bs_version.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/core/presentation/controllers/resource/resource.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/presentation/helpers/helpers.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'try_access_module_controller.g.dart';

@Riverpod(keepAlive: true)
class TryAccessModuleController extends _$TryAccessModuleController {
  bool _isProcessing = false;

  @override
  FutureOr<void> build() {}

  Future<void> tryAccess({
    required BuildContext context,
    required Routes route,
    required int? enterpriseCode,
    required Modules module,
    bool createSubRoute = false,
    Map<String, String>? pathParameters,
    Object? extra,
  }) async {
    if (_isProcessing || state.isLoading) return;
    _isProcessing = true;

    final minimumDateLoadRequestType = DateTime(2026, 5, 7);
    final minimumBsVersionDate = switch (route) {
      Routes.searchSaleRequests => DateTime(2026, 3, 26),
      Routes.createSaleRequest => minimumDateLoadRequestType,
      Routes.saleRequestRequestsTypes => minimumDateLoadRequestType,
      Routes.transferRequestRequestsTypes => minimumDateLoadRequestType,
      Routes.processAuthorization => DateTime(2026, 7, 17),
      Routes.insertUpdateSaleRequest => DateTime(2026, 6, 22),
      Routes.adjustCost => DateTime(2026, 3, 31),
      Routes.searchBuyRequests => DateTime(2026, 7, 25),
      Routes.shallowBuyMovement => DateTime(2026, 7, 25),
      Routes.buyMovementDetails => DateTime(2026, 7, 25),
      Routes.synchronizer => DateTime(2026, 8, 10),
      _ => null,
    };

    state = const AsyncValue.loading();
    try {
      state = await AsyncValue.guard(() async {
        if (minimumBsVersionDate != null) {
          final bsVersionDate = await ref.read(
            bsVersionStateControllerProvider.future,
          );

          if (bsVersionDate?.isBefore(minimumBsVersionDate) ?? false) {
            if (kDebugMode) {
              dev.log('Continuing because it is on debug mode');
            } else {
              if (!context.mounted) return;
              showAlertDialog(
                context: context,
                title: 'Atualize o BS'.hardcoded,
                content:
                    'A versão do BS precisa ser atualizada para utilizar essa funcionalidade'
                        .hardcoded,
              );
            }
          }
        }

        if (!context.mounted) return;
        final router = GoRouter.of(context);
        final String? currentRouteName =
            router.routerDelegate.currentConfiguration.last.route.name;

        if (currentRouteName == route.name) {
          throw AppException('Você já está no módulo desejado');
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

        if ((enabledModulesBySelectedEnterprise == null ||
            !enabledModulesBySelectedEnterprise.enabledModules.contains(
              module,
            ))) {
          if (!context.mounted) return;
          if (kDebugMode || ModuleIsFreeUntil.isFree(module)) {
            dev.log('Continuing because it is on debug mode');
          } else {
            _showDisabledModuleMessage(context, module);
            return;
          }
        }

        if (module == Modules.adjustPrice ||
            module == Modules.processAuthorization) {
          final BsRoutine routine;
          final BsResource resource;
          if (module == Modules.adjustPrice) {
            routine = BsRoutine.adjustSalePrice;
            resource = BsResource.adjustSalePrice;
          } else {
            routine = BsRoutine.generic;
            resource = BsResource.processAuthorizationRules;
          }

          final canAccess = await _canAccessModule(routine, resource);

          if (!canAccess && context.mounted) {
            if (kDebugMode) {
              dev.log('Continuing because it is on debug mode');
            } else {
              _showUserWithoutPermissionMessage(context, resource);
              return;
            }
          }
        }

        if (!context.mounted) return;
        if (createSubRoute == true) {
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
    } finally {
      Future.delayed(const Duration(milliseconds: 800), () {
        _isProcessing = false;
      });
    }
  }

  Future<bool> _canAccessModule(BsRoutine routine, BsResource resource) async {
    final provider = canAccessResourceStateControllerProvider(
      routine,
      resource,
    );

    if (ref.read(provider) is AsyncError) {
      ref.invalidate(provider);
    }
    return await ref.read(provider.future);
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

void _showUserWithoutPermissionMessage(
  BuildContext context,
  BsResource resource,
) {
  showAlertDialog(
    context: context,
    title: 'Usuário sem permissão'.hardcoded,
    content:
        'Seu usuário não possui permissão para: ${resource.name}'.hardcoded,
  );
}
