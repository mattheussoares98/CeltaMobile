import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/home/presentation/pages/components/components.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonsByModuleItems {
  ButtonsByModuleItems._();

  static const Map<Modules, DefaultModuleButton> buttonByModule = {
    Modules.adjustCost: DefaultModuleButton(
      route: Routes.adjustCost,
      module: Modules.adjustCost,
      platformIcon: PlatformIcon(
        materialIcon: Icons.price_change_outlined,
        cupertinoIcon: CupertinoIcons.money_dollar,
      ),
    ),
    Modules.adjustPrice: DefaultModuleButton(
      route: Routes.adjustSalePriceProducts,
      module: Modules.adjustPrice,
      platformIcon: PlatformIcon(
        materialIcon: Icons.sell_outlined,
        cupertinoIcon: CupertinoIcons.tag,
      ),
    ),
    Modules.adjustStock: DefaultModuleButton(
      route: Routes.adjustStocks,
      module: Modules.adjustStock,
      platformIcon: PlatformIcon(
        materialIcon: Icons.inventory_2_outlined,
        cupertinoIcon: CupertinoIcons.archivebox,
      ),
    ),
    Modules.customerRegister: DefaultModuleButton(
      passEnterpriseToNextRoute: false,
      route: Routes.customerRegister,
      module: Modules.customerRegister,
      platformIcon: PlatformIcon(
        materialIcon: Icons.person_add_outlined,
        cupertinoIcon: CupertinoIcons.person_badge_plus,
      ),
    ),
    Modules.transferBetweenStocks: DefaultModuleButton(
      route: Routes.transferBetweenStocks,
      module: Modules.transferBetweenStocks,
      platformIcon: PlatformIcon(
        materialIcon: Icons.multiple_stop_outlined,
        cupertinoIcon: CupertinoIcons.arrow_right_arrow_left,
      ),
    ),
    Modules.searchProducts: DefaultModuleButton(
      route: Routes.searchProducts,
      module: Modules.searchProducts,
      platformIcon: PlatformIcon(
        materialIcon: Icons.search_outlined,
        cupertinoIcon: CupertinoIcons.search,
      ),
    ),
    Modules.expeditionConference: DefaultModuleButton(
      route: Routes.expeditionConferenceDocuments,
      module: Modules.expeditionConference,
      platformIcon: PlatformIcon(
        materialIcon: Icons.fact_check_outlined,
        cupertinoIcon: CupertinoIcons.checkmark_seal,
      ),
    ),
    Modules.inventory: DefaultModuleButton(
      route: Routes.inventoryFrozenProcesses,
      module: Modules.inventory,
      platformIcon: PlatformIcon(
        materialIcon: Icons.warehouse_outlined,
        cupertinoIcon: CupertinoIcons.cube_box,
      ),
    ),
    Modules.buyRequest: DefaultModuleButton(
      route: Routes.buyRequestActionSelector,
      module: Modules.buyRequest,
      platformIcon: PlatformIcon(
        materialIcon: Icons.add_shopping_cart_outlined,
        cupertinoIcon: CupertinoIcons.cart_badge_plus,
      ),
    ),
    Modules.buyQuotation: DefaultModuleButton(
      route: Routes.buyQuotations,
      module: Modules.buyQuotation,
      platformIcon: PlatformIcon(
        materialIcon: Icons.request_quote_outlined,
        cupertinoIcon: CupertinoIcons.doc_text_search,
      ),
    ),
    Modules.transferRequest: DefaultModuleButton(
      route: Routes.transferRequestRequestsTypes,
      module: Modules.transferRequest,
      platformIcon: PlatformIcon(
        materialIcon: Icons.sync_alt_outlined,
        cupertinoIcon: CupertinoIcons.arrow_2_squarepath,
      ),
    ),
    Modules.saleRequest: DefaultModuleButton(
      route: Routes.saleRequestActionSelector,
      module: Modules.saleRequest,
      platformIcon: PlatformIcon(
        materialIcon: Icons.shopping_bag_outlined,
        cupertinoIcon: CupertinoIcons.bag,
      ),
    ),
    Modules.competingPrices: DefaultModuleButton(
      route: Routes.competingPricesResearchs,
      module: Modules.competingPrices,
      platformIcon: PlatformIcon(
        materialIcon: Icons.compare_arrows_outlined,
        cupertinoIcon: CupertinoIcons.arrow_left_right_square,
      ),
    ),
    Modules.receipt: DefaultModuleButton(
      route: Routes.receipts,
      module: Modules.receipt,
      platformIcon: PlatformIcon(
        materialIcon: Icons.receipt_long_outlined,
        cupertinoIcon: CupertinoIcons.doc_text,
      ),
    ),
    Modules.reports: DefaultModuleButton(
      route: Routes.reports,
      module: Modules.reports,
      platformIcon: PlatformIcon(
        materialIcon: Icons.analytics_outlined,
        cupertinoIcon: CupertinoIcons.chart_bar_square,
      ),
      passEnterpriseToNextRoute: false,
    ),
    Modules.stockReplacement: DefaultModuleButton(
      route: Routes.stockReplacement,
      module: Modules.stockReplacement,
      platformIcon: PlatformIcon(
        materialIcon: Icons.published_with_changes_outlined,
        cupertinoIcon: CupertinoIcons.arrow_2_circlepath_circle,
      ),
    ),
    Modules.processAuthorization: DefaultModuleButton(
      route: Routes.processAuthorization,
      module: Modules.processAuthorization,
      platformIcon: PlatformIcon(
        materialIcon: Icons.lock_person,
        cupertinoIcon: CupertinoIcons.lock_fill,
      ),
    ),
    Modules.synchronizer: DefaultModuleButton(
      route: Routes.synchronizer,
      module: Modules.synchronizer,
      platformIcon: PlatformIcon(
        materialIcon: Icons.sync_outlined,
        cupertinoIcon: CupertinoIcons.repeat,
      ),
      passEnterpriseToNextRoute: false,
    ),
    Modules.buyMovement: DefaultModuleButton(
      route: Routes.shallowBuyMovement,
      module: Modules.buyMovement,
      platformIcon: PlatformIcon(
        materialIcon: Icons.shopping_basket,
        cupertinoIcon: CupertinoIcons.gift,
      ),
    ),
    Modules.printLabel: DefaultModuleButton(
      route: Routes.printLabelLayoutSummaries,
      module: Modules.printLabel,
      platformIcon: PlatformIcon(
        materialIcon: Icons.print_outlined,
        cupertinoIcon: CupertinoIcons.printer,
      ),
    ),
  };
}
