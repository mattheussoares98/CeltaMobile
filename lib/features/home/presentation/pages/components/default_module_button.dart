import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../routing/routing.dart';

class DefaultModuleButton extends StatelessWidget {
  final EnterpriseEntity? selectedEnterprise;
  final Routes route;
  final Modules module;
  final AsyncValue<List<EnabledModulesByCnpjEntity>>
  enabledModulesByEnterpriseAsync;
  final bool passEnterpriseToNextRoute;

  const DefaultModuleButton({
    super.key,
    required this.selectedEnterprise,
    required this.route,
    required this.enabledModulesByEnterpriseAsync,
    required this.module,
    this.passEnterpriseToNextRoute = true,
  });

  @override
  Widget build(BuildContext context) {
    void showDisabledModuleMessage() {
      showAlertDialog(
        context: context,
        title: 'Módulo desabilitado'.hardcoded,
        content:
            'O módulo ${route.module.toUpperCase()} está desabilitado para essa empresa. Caso queira habilitar, entre em contato com o setor administrativo'
                .hardcoded,
      );
    }

    return PrimaryButton(
      text: route.module,
      onPressed: selectedEnterprise == null
          ? null
          : () {
              final enterpriseIndex = enabledModulesByEnterpriseAsync.value
                  ?.indexWhere(
                    (e) => e.cnpjNumber == selectedEnterprise!.CnpjNumber,
                  );
              if (enterpriseIndex == null || enterpriseIndex == -1) {
                showDisabledModuleMessage();
                return;
              }

              final enabledModules = enabledModulesByEnterpriseAsync
                  .value?[enterpriseIndex]
                  .enabledModules;

              bool moduleIsEnabled = enabledModules?.contains(module) ?? false;

              if (!moduleIsEnabled) {
                showDisabledModuleMessage();
                return;
              }

              context.goNamed(
                route.name,
                pathParameters: passEnterpriseToNextRoute
                    ? {'enterpriseCode': selectedEnterprise!.Code.toString()}
                    : {},
              );
            },
    );
  }
}
