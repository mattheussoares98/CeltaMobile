// lib/features/home/presentation/pages/components/action_selector/sale_request_actions.dart
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/home/presentation/model/model.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class BuyRequestActions {
  static List<PageActionSelectorModel> get(BuildContext context) => [
    PageActionSelectorModel(
      title: 'Criar'.hardcoded,
      subtitle: 'Crie pedido de compras'.hardcoded,
      platformIcon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.add_circled,
        materialIcon: Icons.add_circle_outline,
        color: context.theme.primaryColor,
      ),
      color: context.theme.primaryColor,
      route: Routes.createBuyRequest,
    ),
    PageActionSelectorModel(
      title: 'Pesquisar'.hardcoded,
      subtitle: 'Pesquise pedidos de compras'.hardcoded,
      platformIcon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.search,
        materialIcon: Icons.search,
        color: context.theme.colorScheme.secondary,
      ),
      color: context.theme.colorScheme.secondary,
      route: Routes.searchBuyRequests,
    ),
  ];
}
