import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../routing/routing.dart';
import '../components.dart';

class ButtonsByModuleItems {
  ButtonsByModuleItems._();

  static final Map<Modules, DefaultModuleButton> buttonByModule = {
    Modules.adjustPrice: const DefaultModuleButton(
      route: Routes.adjustSalePriceProducts,
      module: Modules.adjustPrice,
      materialIcon: Icons.sell_outlined,
      cupertinoIcon: CupertinoIcons.tag,
    ),
    Modules.adjustStock: const DefaultModuleButton(
      route: Routes.adjustStocks,
      module: Modules.adjustStock,
      materialIcon: Icons.inventory_2_outlined,
      cupertinoIcon: CupertinoIcons.archivebox,
    ),
    Modules.customerRegister: const DefaultModuleButton(
      passEnterpriseToNextRoute: false,
      route: Routes.customerRegister,
      module: Modules.customerRegister,
      materialIcon: Icons.person_add_outlined,
      cupertinoIcon: CupertinoIcons.person_badge_plus,
    ),
    Modules.transferBetweenStocks: const DefaultModuleButton(
      route: Routes.transferBetweenStocks,
      module: Modules.transferBetweenStocks,
      materialIcon: Icons.multiple_stop_outlined,
      cupertinoIcon: CupertinoIcons.arrow_right_arrow_left,
    ),
    Modules.searchProducts: const DefaultModuleButton(
      route: Routes.searchProducts,
      module: Modules.searchProducts,
      materialIcon: Icons.search_outlined,
      cupertinoIcon: CupertinoIcons.search,
    ),
    Modules.expeditionConference: const DefaultModuleButton(
      route: Routes.expeditionConferenceDocuments,
      module: Modules.expeditionConference,
      materialIcon: Icons.fact_check_outlined,
      cupertinoIcon: CupertinoIcons.checkmark_seal,
    ),
    Modules.inventory: const DefaultModuleButton(
      route: Routes.inventoryFrozenProcesses,
      module: Modules.inventory,
      materialIcon: Icons.warehouse_outlined,
      cupertinoIcon: CupertinoIcons.cube_box,
    ),
    Modules.buyRequest: const DefaultModuleButton(
      route: Routes.buyRequest,
      module: Modules.buyRequest,
      materialIcon: Icons.add_shopping_cart_outlined,
      cupertinoIcon: CupertinoIcons.cart_badge_plus,
    ),
    Modules.buyQuotation: const DefaultModuleButton(
      route: Routes.buyQuotations,
      module: Modules.buyQuotation,
      materialIcon: Icons.request_quote_outlined,
      cupertinoIcon: CupertinoIcons.doc_text_search,
    ),
    Modules.transferRequest: const DefaultModuleButton(
      route: Routes.transferRequestRequestsTypes,
      module: Modules.transferRequest,
      materialIcon: Icons.sync_alt_outlined,
      cupertinoIcon: CupertinoIcons.arrow_2_squarepath,
    ),
    Modules.saleRequest: const DefaultModuleButton(
      route: Routes.saleRequestActionSelector,
      module: Modules.saleRequest,
      materialIcon: Icons.shopping_bag_outlined,
      cupertinoIcon: CupertinoIcons.bag,
    ),
    Modules.competingPrices: const DefaultModuleButton(
      route: Routes.competingPricesResearchs,
      module: Modules.competingPrices,
      materialIcon: Icons.compare_arrows_outlined,
      cupertinoIcon: CupertinoIcons.arrow_left_right_square,
    ),
    Modules.receipt: const DefaultModuleButton(
      route: Routes.receipts,
      module: Modules.receipt,
      materialIcon: Icons.receipt_long_outlined,
      cupertinoIcon: CupertinoIcons.doc_text,
    ),
    Modules.reports: const DefaultModuleButton(
      route: Routes.reports,
      module: Modules.reports,
      materialIcon: Icons.analytics_outlined,
      cupertinoIcon: CupertinoIcons.chart_bar_square,
      passEnterpriseToNextRoute: false,
    ),
    Modules.stockReplacement: DefaultModuleButton(
      route: Routes.stockReplacement,
      module: Modules.stockReplacement,
      materialIcon: Icons.published_with_changes_outlined,
      cupertinoIcon: CupertinoIcons.arrow_2_circlepath_circle,
      minimumBsVersionDate: DateTime(2026, 2, 9),
    ),
  };
}
