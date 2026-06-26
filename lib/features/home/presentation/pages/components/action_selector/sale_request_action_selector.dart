import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/home/presentation/pages/components/action_selector/action_selector.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// PERFORMANCE: A standalone, optimized Modal Bottom Sheet for
/// selecting the Sale Request workflow. Using a Stateless widget
/// here keeps the memory footprint minimal.
class SaleRequestActionSelector extends StatelessWidget {
  const SaleRequestActionSelector({super.key});

  /// Static helper to trigger the modal consistently across the app.
  static Future<Routes?> show(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const SaleRequestActionSelector(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          Sizes.p16,
          Sizes.p12,
          Sizes.p16,
          Sizes.p80,
        ),
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Sizes.p24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle for visual feedback (drag indicator)
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: Sizes.p20),
                decoration: BoxDecoration(
                  color: context.theme.dividerColor.withAlpha(100),
                  borderRadius: BorderRadius.circular(Sizes.p4),
                ),
              ),
              const _Title(),
              gapH24,
              const _CreateSaleRequestAction(),
              gapH12,
              const _SearchSaleRequestAction(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchSaleRequestAction extends StatelessWidget {
  const _SearchSaleRequestAction();

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      title: 'Pesquisar'.hardcoded,
      subtitle: 'Pesquise pedidos de vendas'.hardcoded,
      icon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.search,
        materialIcon: Icons.search,
        color: context.theme.colorScheme.secondary,
        size: 28,
      ),
      color: context.theme.colorScheme.secondary,
      onTap: () => Navigator.pop(context, Routes.searchSaleRequests),
    );
  }
}

class _CreateSaleRequestAction extends StatelessWidget {
  const _CreateSaleRequestAction();

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      title: 'Criar'.hardcoded,
      subtitle: 'Crie pedidos de venda'.hardcoded,
      icon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.add_circled,
        materialIcon: Icons.add_circle_outline,
        color: context.theme.primaryColor,
        size: 28,
      ),
      color: context.theme.primaryColor,
      onTap: () => Navigator.pop(context, Routes.saleRequestRequestsTypes),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Pedido de Vendas'.hardcoded,
      style: context.theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
