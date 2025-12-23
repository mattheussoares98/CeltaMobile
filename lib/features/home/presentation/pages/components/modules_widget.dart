import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../routing/routing.dart';
import 'components.dart';

class ModulesWidget extends ConsumerWidget {
  const ModulesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttons = <DefaultModuleButton>[
      const DefaultModuleButton(
        route: Routes.adjustSalePriceProducts,
        module: Modules.adjustPrice,
      ),
      const DefaultModuleButton(
        route: Routes.adjustStocks,
        module: Modules.adjustStock,
      ),
      const DefaultModuleButton(
        route: Routes.customerRegister,
        module: Modules.customerRegister,
        passEnterpriseToNextRoute: false,
      ),
      const DefaultModuleButton(
        route: Routes.transferBetweenStocks,
        module: Modules.transferBetweenStocks,
      ),
      const DefaultModuleButton(
        route: Routes.searchProducts,
        module: Modules.searchProducts,
      ),
      const DefaultModuleButton(
        route: Routes.expeditionConferenceDocuments,
        module: Modules.expeditionConference,
      ),
      const DefaultModuleButton(
        route: Routes.inventoryFrozenProcesses,
        module: Modules.inventory,
      ),
      const DefaultModuleButton(
        passEnterpriseToNextRoute: false,
        route: Routes.buyRequest,
        module: Modules.buyRequest,
      ),
      const DefaultModuleButton(
        route: Routes.buyQuotations,
        module: Modules.buyQuotation,
      ),
      const DefaultModuleButton(
        passEnterpriseToNextRoute: false,
        route: Routes.transferRequestRequestsTypes,
        module: Modules.transferRequest,
      ),
      const DefaultModuleButton(
        route: Routes.saleRequestRequestsTypes,
        module: Modules.saleRequest,
      ),
      const DefaultModuleButton(
        route: Routes.competingPricesResearchs,
        module: Modules.competingPrices,
      ),
      const DefaultModuleButton(
        route: Routes.receipts,
        module: Modules.receipt,
      ),
      const DefaultModuleButton(
        route: Routes.reports,
        module: Modules.reports,
        passEnterpriseToNextRoute: false,
      ),
    ];

    buttons.sort((a, b) => a.route.module.compareTo(b.route.module));

    return Padding(
      padding: const EdgeInsets.all(Sizes.p4),
      child: GridView.builder(
        itemCount: buttons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: Sizes.p4,
          mainAxisSpacing: Sizes.p4,
          mainAxisExtent: 120,
        ),
        itemBuilder: (_, index) {
          final button = buttons[index];
          return button;
        },
      ),
    );
  }
}
