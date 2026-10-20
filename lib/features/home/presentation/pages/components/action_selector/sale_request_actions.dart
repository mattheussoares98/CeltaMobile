// lib/features/home/presentation/pages/components/action_selector/sale_request_actions.dart
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/home/presentation/model/model.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class SaleRequestActions {
  static List<PageActionSelectorModel> get(BuildContext context) => [
    PageActionSelectorModel(
      title: context.l10n.create,
      subtitle: context.l10n.createSalesOrders,
      platformIcon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.add_circled,
        materialIcon: Icons.add_circle_outline,
        color: context.theme.primaryColor,
      ),
      color: context.theme.primaryColor,
      route: Routes.saleRequestRequestsTypes,
    ),
    PageActionSelectorModel(
      title: context.l10n.search,
      subtitle: context.l10n.searchSalesOrders,
      platformIcon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.search,
        materialIcon: Icons.search,
        color: context.theme.colorScheme.secondary,
      ),
      color: context.theme.colorScheme.secondary,
      route: Routes.searchSaleRequests,
    ),
  ];
}
