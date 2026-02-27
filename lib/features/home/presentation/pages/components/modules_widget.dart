import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/controllers.dart';
import 'components.dart';

/// This prevents the UI from re-calculating the order on every rebuild cycle.
final favoriteModulesSetProvider = Provider<Set<Modules>>((ref) {
  final list = ref.watch(
    favoriteModulesStateControllerProvider.select(
      (s) => s.value ?? const <Modules>[],
    ),
  );
  return list.toSet();
});

/// Prevents the UI from re-calculating the order on every rebuild cycle.
final sortedModulesProvider = Provider<List<Modules>>((ref) {
  final favoriteModules = ref.watch(
    favoriteModulesStateControllerProvider.select(
      (s) => s.value ?? const <Modules>[],
    ),
  );

  final modules = Modules.values.toList();
  final favIndex = {
    for (int i = 0; i < favoriteModules.length; i++) favoriteModules[i]: i,
  };

  modules.sort((a, b) {
    final ia = favIndex[a];
    final ib = favIndex[b];
    if (ia != null && ib != null) return ib.compareTo(ia); // newest first
    if (ia != null) return -1;
    if (ib != null) return 1;
    return a.index.compareTo(b.index);
  });

  return modules;
});

class ModulesWidget extends ConsumerStatefulWidget {
  const ModulesWidget({super.key});

  @override
  ConsumerState<ModulesWidget> createState() => _ModulesWidgetState();
}

class _ModulesWidgetState extends ConsumerState<ModulesWidget> {
  static final Map<Modules, DefaultModuleButton> _buttonByModule = {
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
      route: Routes.saleRequestRequestsTypes,
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

  int _calculateCrossAxisCount(double width) {
    if (width > 700) return 4;
    final floor = (width / 160).floor();
    return floor < 2 ? 1 : floor;
  }

  double _calculateTotalHeight(
    int itemCount,
    int crossAxisCount,
    double height,
    double spacing,
  ) {
    final rowCount = (itemCount / crossAxisCount).ceil();
    return (rowCount * (height + spacing)) + spacing;
  }

  @override
  Widget build(BuildContext context) {
    // when the actual order changes.
    final currentOrder = ref.watch(sortedModulesProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = _calculateCrossAxisCount(width);

        const double itemHeight = 90;
        const double spacing = Sizes.p4;
        final double itemWidth =
            (width - (spacing * (crossAxisCount + 1))) / crossAxisCount;

        final double totalHeight = _calculateTotalHeight(
          currentOrder.length,
          crossAxisCount,
          itemHeight,
          spacing,
        );

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(spacing),
            child: SizedBox(
              height: totalHeight,
              child: RepaintBoundary(
                child: Stack(
                  children: [
                    for (int i = 0; i < currentOrder.length; i++)
                      _AnimatedModuleTile(
                        key: ValueKey(currentOrder[i]),
                        module: currentOrder[i],
                        index: i,
                        itemWidth: itemWidth,
                        itemHeight: itemHeight,
                        spacing: spacing,
                        crossAxisCount: crossAxisCount,
                        child: _buttonByModule[currentOrder[i]]!,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedModuleTile extends StatelessWidget {
  final Modules module;
  final int index;
  final double itemWidth;
  final double itemHeight;
  final double spacing;
  final int crossAxisCount;
  final Widget child;

  const _AnimatedModuleTile({
    super.key,
    required this.module,
    required this.index,
    required this.itemWidth,
    required this.itemHeight,
    required this.spacing,
    required this.crossAxisCount,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final row = index ~/ crossAxisCount;
    final col = index % crossAxisCount;
    final double left = col * (itemWidth + spacing);
    final double top = row * (itemHeight + spacing);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      left: left,
      top: top,
      width: itemWidth,
      height: itemHeight,
      child: RepaintBoundary(child: child),
    );
  }
}
