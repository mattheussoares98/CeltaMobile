import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/enterprises/enterprises.dart';
import '../../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../../routing/routing.dart';
import '../../../../enterprises/presentation/controllers/controllers.dart';

class DefaultModuleButton extends ConsumerWidget {
  final Routes route;
  final Modules module;
  final bool passEnterpriseToNextRoute;

  const DefaultModuleButton({
    super.key,
    required this.route,
    required this.module,
    this.passEnterpriseToNextRoute = true,
  });

  String get imagePath {
    switch (module) {
      case Modules.adjustStock:
        return 'lib/core/assets/images/adjust_stock.png';
      default:
        return 'lib/core/assets/images/adjust_stock.png';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );

    final enterpriseName = ref.watch(
      validatedUserSessionProvider.select((s) => s.value!.enterprise!.name),
    );

    final enabledModulesByEnterpriseAsync = ref.watch(
      enabledModulesByEnterpriseNameStateControllerProvider(enterpriseName),
    );

    void showDisabledModuleMessage() {
      showAlertDialog(
        context: context,
        title: 'Módulo desabilitado'.hardcoded,
        content:
            'O módulo ${route.module.toUpperCase()} está desabilitado para essa empresa. Caso queira habilitar, entre em contato com o setor administrativo'
                .hardcoded,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            InkWell(
              onTap: selectedEnterprise == null
                  ? null
                  : () {
                      final enterpriseIndex = enabledModulesByEnterpriseAsync
                          .value
                          ?.indexWhere(
                            (e) =>
                                e.cnpjNumber == selectedEnterprise.CnpjNumber,
                          );
                      if (enterpriseIndex == null || enterpriseIndex == -1) {
                        showDisabledModuleMessage();
                        return;
                      }

                      final enabledModules = enabledModulesByEnterpriseAsync
                          .value?[enterpriseIndex]
                          .enabledModules;

                      bool moduleIsEnabled =
                          enabledModules?.contains(module) ?? false;

                      if (!moduleIsEnabled) {
                        showDisabledModuleMessage();
                        return;
                      }

                      context.goNamed(
                        route.name,
                        pathParameters: passEnterpriseToNextRoute
                            ? {
                                'enterpriseCode':
                                    selectedEnterprise.Code.toString(),
                              }
                            : {},
                      );
                    },
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: constraints.maxHeight,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: constraints.maxHeight / 4,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withAlpha(160),
                      Colors.black.withAlpha(120),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: Sizes.p4),
                    child: Text(
                      route.module,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
