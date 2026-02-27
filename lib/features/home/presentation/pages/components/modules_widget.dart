import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../routing/routing.dart';
import '../../controllers/controllers.dart';
import 'components.dart';

class ModulesWidget extends ConsumerStatefulWidget {
  const ModulesWidget({super.key});

  @override
  ConsumerState<ModulesWidget> createState() => _ModulesWidgetState();
}

class _ModulesWidgetState extends ConsumerState<ModulesWidget> {
  // Track previous order so we only animate when positions change.
  List<Modules> _prevOrder = const [];
  bool _firstBuild = true;

  static final DateTime _minStockReplacementVersion = DateTime(2026, 2, 9);

  // Build the buttons ONCE and reuse the same widget instances.
  // The keys must be stable and unique.
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
      minimumBsVersionDate: _minStockReplacementVersion,
    ),
  };

  static int _getCrossAxisCount(BoxConstraints constraints) {
    final floor = (constraints.maxWidth / 160).floor();
    if (floor < 2) return 1;
    if (constraints.maxWidth > 700) return 4;
    return floor;
  }

  List<Modules> _sortedModules(List<Modules> favoriteModules) {
    final favIndex = <Modules, int>{
      for (int i = 0; i < favoriteModules.length; i++) favoriteModules[i]: i,
    };

    final modules = _buttonByModule.keys.toList();

    modules.sort((a, b) {
      final ia = favIndex[a];
      final ib = favIndex[b];

      final aFav = ia != null;
      final bFav = ib != null;

      if (aFav && bFav) return ib.compareTo(ia); // newest first
      if (aFav) return -1;
      if (bFav) return 1;

      // fallback alphabetical by route.module
      final ra = _buttonByModule[a]!.route.module;
      final rb = _buttonByModule[b]!.route.module;
      return ra.compareTo(rb);
    });

    return modules;
  }

  bool _sameOrder(List<Modules> a, List<Modules> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final favoriteModules = ref.watch(
      favoriteModulesStateControllerProvider.select(
        (s) => s.value ?? const <Modules>[],
      ),
    );

    final order = _sortedModules(favoriteModules);

    // Animate ONLY when order actually changed, and skip first build animation.
    final shouldAnimate = !_firstBuild && !_sameOrder(order, _prevOrder);
    final duration = shouldAnimate
        ? const Duration(milliseconds: 600)
        : Duration.zero;

    _prevOrder = order;
    _firstBuild = false;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = _getCrossAxisCount(constraints);

          const double itemHeight = 90;
          const double spacing = Sizes.p4;

          final double itemWidth =
              (width - (spacing * (crossAxisCount + 1))) / crossAxisCount;

          final int rowCount = (order.length / crossAxisCount).ceil();
          final double totalHeight =
              rowCount * (itemHeight + spacing) + spacing;

          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              height: totalHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacing),
                child: Stack(
                  children: List.generate(order.length, (index) {
                    final module = order[index];
                    final button = _buttonByModule[module]!;

                    final row = index ~/ crossAxisCount;
                    final col = index % crossAxisCount;

                    final left = col * (itemWidth + spacing);
                    final top = row * (itemHeight + spacing);

                    return AnimatedPositioned(
                      key: ValueKey('anim_module_${button.route.name}'),
                      duration: duration,
                      curve: Curves.easeInOutCubic,
                      left: left,
                      top: top,
                      width: itemWidth,
                      height: itemHeight,
                      child: RepaintBoundary(child: button),
                    );
                  }),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
