import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../routing/routing.dart';
import '../../../../enterprise_manager/domain/entities/entities.dart';
import '../../../../enterprise_manager/presentation/controllers/controllers.dart';
import '../../../../enterprises/presentation/controllers/controllers.dart';
import 'components.dart';

class ModulesWidget extends ConsumerWidget {
  const ModulesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEnterprise = ref.watch(
      selectedEnterpriseStateControllerProvider,
    );

    final userSession = ref.watch(validatedUserSessionProvider);

    final enabledModulesByEnterpriseAsync = ref.watch(
      enabledModulesByEnterpriseNameStateControllerProvider(
        userSession.value!.enterprise!.name,
      ),
    );

    final buttons = <DefaultModuleButton>[
      DefaultModuleButton(
        enabledModulesByEnterpriseAsync: enabledModulesByEnterpriseAsync,
        selectedEnterprise: selectedEnterprise,
        route: AppRoute.adjustSalePriceProducts,
        module: Modules.adjustPrice,
      ),
      DefaultModuleButton(
        enabledModulesByEnterpriseAsync: enabledModulesByEnterpriseAsync,
        selectedEnterprise: selectedEnterprise,
        route: AppRoute.adjustStocks,
        module: Modules.adjustStock,
      ),
      DefaultModuleButton(
        enabledModulesByEnterpriseAsync: enabledModulesByEnterpriseAsync,
        selectedEnterprise: selectedEnterprise,
        route: AppRoute.customerRegister,
        module: Modules.customerRegister,
        passEnterpriseToNextRoute: false,
      ),
      DefaultModuleButton(
        enabledModulesByEnterpriseAsync: enabledModulesByEnterpriseAsync,
        selectedEnterprise: selectedEnterprise,
        route: AppRoute.transferBetweenStocks,
        module: Modules.transferBetweenStocks,
      ),
    ];

    buttons.sort((a, b) => a.route.module.compareTo(b.route.module));

    return Padding(
      padding: const EdgeInsets.all(Sizes.p4),
      child: ResponsiveListFlow(
        maxItemWidth: 175,
        itemCount: buttons.length,
        itemBuilder: (_, index) {
          final button = buttons[index];
          return button;
        },
      ),
    );
  }
}
