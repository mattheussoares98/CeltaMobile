import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/controllers.dart';
import 'components.dart';

/// PERFORMANCE: Pre-computing the sorted list and an index map.
/// Storing the map allows findChildIndexCallback to work in O(1) time.
class SortedModulesData {
  final List<Modules> list;
  final Map<Modules, int> indexMap;
  SortedModulesData(this.list, this.indexMap);
}

final sortedModulesProvider = Provider<SortedModulesData>((ref) {
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

  /// PERFORMANCE: Using a static map to avoid widget recreation.
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

class MyGridView extends ConsumerWidget {
  const MyGridView({
    super.key,
    required this.spacing,
    required this.crossAxisCount,
  });

  final double spacing;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // PERFORMANCE: RepaintBoundary on the entire Grid prevents parent elements
    // from repainting during reorder animations.
    final data = ref.watch(sortedModulesProvider);
    return GridView.custom(
      padding: EdgeInsets.all(spacing),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        mainAxisExtent: 90,
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        (context, index) {
          final module = data.list[index];
          return _PulsingModuleTile(
            // PERFORMANCE: Stable identity-based key.
            key: ValueKey(module),
            module: module,
            child: ModulesWidget._buttonByModule[module]!,
          );
        },
        childCount: data.list.length,
        // PERFORMANCE: findChildIndexCallback allows Flutter to relocate
        // the existing Element in O(1) time using our pre-computed Map.
        findChildIndexCallback: (Key key) {
          if (key is ValueKey<Modules>) {
            return data.indexMap[key.value];
          }
          return null;
        },
      ),
    );
  }
}

class _PulsingModuleTile extends ConsumerStatefulWidget {
  final Modules module;
  final Widget child;

  const _PulsingModuleTile({
    super.key,
    required this.module,
    required this.child,
  });

  @override
  ConsumerState<_PulsingModuleTile> createState() => _PulsingModuleTileState();
}

class _PulsingModuleTileState extends ConsumerState<_PulsingModuleTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // PERFORMANCE: Pulse logic is isolated to this specific widget.
    ref.listen<bool>(
      favoriteModulesStateControllerProvider.select(
        (s) => s.value?.contains(widget.module) ?? false,
      ),
      (previous, next) {
        if (previous != null && previous != next) {
          _pulseController.forward(from: 0);
        }
      },
    );

    return ScaleTransition(
      scale: _scaleAnimation,
      // PERFORMANCE: Each tile is cached, so the Move/Snap reorder
      // only requires updating the GPU position matrix.
      child: RepaintBoundary(child: widget.child),
    );
  }
}
