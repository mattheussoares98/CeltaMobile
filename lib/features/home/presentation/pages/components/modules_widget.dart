import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../routing/routing.dart';
import '../../controllers/controllers.dart';
import 'components.dart';

class ModulesWidget extends ConsumerWidget {
  const ModulesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttons = <DefaultModuleButton>[
      const DefaultModuleButton(
        route: Routes.adjustSalePriceProducts,
        module: Modules.adjustPrice,
        materialIcon: Icons.sell_outlined,
        cupertinoIcon: CupertinoIcons.tag,
      ),
      const DefaultModuleButton(
        route: Routes.adjustStocks,
        module: Modules.adjustStock,
        materialIcon: Icons.inventory_2_outlined,
        cupertinoIcon: CupertinoIcons.archivebox,
      ),
      const DefaultModuleButton(
        route: Routes.customerRegister,
        module: Modules.customerRegister,
        materialIcon: Icons.person_add_outlined,
        cupertinoIcon: CupertinoIcons.person_badge_plus,

        passEnterpriseToNextRoute: false,
      ),
      const DefaultModuleButton(
        route: Routes.transferBetweenStocks,
        module: Modules.transferBetweenStocks,
        materialIcon: Icons.multiple_stop_outlined,
        cupertinoIcon: CupertinoIcons.arrow_right_arrow_left,
      ),
      const DefaultModuleButton(
        route: Routes.searchProducts,
        module: Modules.searchProducts,
        materialIcon: Icons.search_outlined,
        cupertinoIcon: CupertinoIcons.search,
      ),
      const DefaultModuleButton(
        route: Routes.expeditionConferenceDocuments,
        module: Modules.expeditionConference,
        materialIcon: Icons.fact_check_outlined,
        cupertinoIcon: CupertinoIcons.checkmark_seal,
      ),
      const DefaultModuleButton(
        route: Routes.inventoryFrozenProcesses,
        module: Modules.inventory,
        materialIcon: Icons.warehouse_outlined,
        cupertinoIcon: CupertinoIcons.cube_box,
      ),
      const DefaultModuleButton(
        passEnterpriseToNextRoute: false,
        route: Routes.buyRequest,
        module: Modules.buyRequest,
        materialIcon: Icons.add_shopping_cart_outlined,
        cupertinoIcon: CupertinoIcons.cart_badge_plus,
      ),
      const DefaultModuleButton(
        route: Routes.buyQuotations,
        module: Modules.buyQuotation,
        materialIcon: Icons.request_quote_outlined,
        cupertinoIcon: CupertinoIcons.doc_text_search,
      ),
      const DefaultModuleButton(
        passEnterpriseToNextRoute: false,
        route: Routes.transferRequestRequestsTypes,
        module: Modules.transferRequest,
        materialIcon: Icons.sync_alt_outlined,
        cupertinoIcon: CupertinoIcons.arrow_2_squarepath,
      ),
      const DefaultModuleButton(
        route: Routes.saleRequestRequestsTypes,
        module: Modules.saleRequest,
        materialIcon: Icons.shopping_bag_outlined,
        cupertinoIcon: CupertinoIcons.bag,
      ),
      const DefaultModuleButton(
        route: Routes.competingPricesResearchs,
        module: Modules.competingPrices,
        materialIcon: Icons.compare_arrows_outlined,
        cupertinoIcon: CupertinoIcons.arrow_left_right_square,
      ),
      const DefaultModuleButton(
        route: Routes.receipts,
        module: Modules.receipt,
        materialIcon: Icons.receipt_long_outlined,
        cupertinoIcon: CupertinoIcons.doc_text,
      ),
      const DefaultModuleButton(
        route: Routes.reports,
        module: Modules.reports,
        materialIcon: Icons.analytics_outlined,
        cupertinoIcon: CupertinoIcons.chart_bar_square,
        passEnterpriseToNextRoute: false,
      ),
    ];

    buttons.sort((a, b) => a.route.module.compareTo(b.route.module));

    int getCrossAxisCount(BoxConstraints constraints) {
      final floor = (constraints.maxWidth / 160).floor();
      if (floor < 2) {
        return 1;
      } else if (constraints.maxWidth > 700) {
        return 4;
      } else {
        return floor;
      }
    }

    return AsyncValueWidget(
      value: ref.watch(favoriteModulesStateControllerProvider),
      tryAgain: () => ref.invalidate(favoriteModulesStateControllerProvider),
      data: (favorites) {
        buttons.sort((a, b) {
          if (favorites.contains(a.module)) {
            return -1;
          } else if (favorites.contains(b.module)) {
            return 1;
          } else {
            return a.route.module.compareTo(b.route.module);
          }
        });

        return LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(Sizes.p4),
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getCrossAxisCount(constraints),
                  mainAxisExtent: 120,
                  childAspectRatio: 1.7,
                ),
                itemBuilder: (_, index) {
                  final button = buttons[index];
                  return button;
                },
              ),
            );
          },
        );
      },
    );
  }
}
