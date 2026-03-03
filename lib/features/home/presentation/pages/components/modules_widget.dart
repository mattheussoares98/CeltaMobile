import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../controllers/controllers.dart';
import 'components.dart';

/// PERFORMANCE: Using an immutable data class with equality checks.
/// This prevents the GridView from rebuilding if the sorted result
/// happens to be identical to the previous one.
@immutable
class SortedModulesData {
  final List<Modules> list;
  final Map<Modules, int> indexMap;

  const SortedModulesData(this.list, this.indexMap);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortedModulesData &&
          const ListEquality().equals(list, other.list);

  @override
  int get hashCode => const ListEquality().hash(list);
}

final sortedModulesProvider = Provider<SortedModulesData>((ref) {
  final favoriteModules = ref.watch(
    favoriteModulesStateControllerProvider.select(
      (s) => s.value ?? const <Modules>[],
    ),
  );

  // PERFORMANCE: Pre-allocate the list with fixed length for better memory efficiency.
  final modules = List<Modules>.of(Modules.values);
  final favIndex = {
    for (int i = 0; i < favoriteModules.length; i++) favoriteModules[i]: i,
  };

  modules.sort((a, b) {
    final ia = favIndex[a];
    final ib = favIndex[b];
    if (ia != null && ib != null) return ib.compareTo(ia);
    if (ia != null) return -1;
    if (ib != null) return 1;
    return a.index.compareTo(b.index);
  });

  final indexMap = {for (int i = 0; i < modules.length; i++) modules[i]: i};
  return SortedModulesData(modules, indexMap);
});

class ModulesWidget extends StatelessWidget {
  const ModulesWidget({super.key});

  /// PERFORMANCE: Using a static map ensures that the button widgets
  /// are treated as constants by the reconciliation engine.
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

  @override
  Widget build(BuildContext context) {
    // PERFORMANCE: Use sizeOf for optimized rebuilds on screen width change only.
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < Breakpoint.tablet;
    const double spacing = Sizes.p4;

    if (isMobile) {
      return const MyGridView(spacing: spacing, crossAxisCount: 2);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 700
            ? 4
            : (constraints.maxWidth / 160).floor().clamp(1, 4);
        return MyGridView(spacing: spacing, crossAxisCount: crossAxisCount);
      },
    );
  }
}

class MyGridView extends StatelessWidget {
  const MyGridView({
    super.key,
    required this.spacing,
    required this.crossAxisCount,
  });

  final double spacing;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    // PERFORMANCE: Using a CustomScrollView with a SliverGrid instead of a
    // GridView with shrinkWrap. shrinkWrap is expensive as it forces
    // a redundant layout pass to calculate total height.
    return RepaintBoundary(
      child: Consumer(
        builder: (context, ref, child) {
          final data = ref.watch(sortedModulesProvider);

          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(spacing),
                sliver: SliverGrid(
                  // PERFORMANCE: Explicitly providing a stable grid delegate
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    mainAxisExtent: 90,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final module = data.list[index];
                      return _StaticModuleTile(
                        key: ValueKey(module),
                        module: module,
                        child: ModulesWidget._buttonByModule[module]!,
                      );
                    },
                    childCount: data.list.length,
                    // PERFORMANCE: findChildIndexCallback is essential for
                    // maintaining the identity of already built items.
                    findChildIndexCallback: (Key key) {
                      if (key is ValueKey<Modules>) {
                        return data.indexMap[key.value];
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StaticModuleTile extends StatelessWidget {
  final Modules module;
  final Widget child;

  const _StaticModuleTile({
    super.key,
    required this.module,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // PERFORMANCE: RepaintBoundary isolates the internal button state
    // from the grid's layout changes.
    return RepaintBoundary(child: child);
  }
}
