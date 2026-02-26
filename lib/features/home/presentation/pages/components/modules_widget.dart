import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        passEnterpriseToNextRoute: false,
        route: Routes.customerRegister,
        module: Modules.customerRegister,
        materialIcon: Icons.person_add_outlined,
        cupertinoIcon: CupertinoIcons.person_badge_plus,
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
      DefaultModuleButton(
        route: Routes.stockReplacement,
        module: Modules.stockReplacement,
        materialIcon: Icons.published_with_changes_outlined,
        cupertinoIcon: CupertinoIcons.arrow_2_circlepath_circle,
        minimumBsVersionDate: DateTime(2026, 02, 09),
      ),
    ];

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

    final favoriteModules = ref.watch(
      favoriteModulesStateControllerProvider.select((s) => s.value ?? []),
    );

    final sortedButtons = [...buttons]
      ..sort((a, b) {
        // We find the position of the modules in the favorites list
        final int indexA = favoriteModules.indexOf(a.module);
        final int indexB = favoriteModules.indexOf(b.module);

        final bool aIsFav = indexA != -1;
        final bool bIsFav = indexB != -1;

        // If both are favorites, we sort them by their appearance in the
        // favoriteModules list in reverse order (newest first).
        if (aIsFav && bIsFav) {
          return indexB.compareTo(indexA);
        }

        // Favorited items always come before non-favorited items
        if (aIsFav && !bIsFav) return -1;
        if (!aIsFav && bIsFav) return 1;

        // Default alphabetical sorting for non-favorited modules
        return a.route.module.compareTo(b.route.module);
      });

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = getCrossAxisCount(constraints);

          // Grid configuration variables
          const double itemHeight = 90;
          const double spacing = Sizes.p4;
          final double itemWidth =
              (width - (spacing * (crossAxisCount + 1))) / crossAxisCount;

          // Calculate total rows to determine the scrollable area height
          final int rowCount = (sortedButtons.length / crossAxisCount).ceil();
          final double totalHeight =
              rowCount * (itemHeight + spacing) + spacing;

          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              height: totalHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacing),
                child: Stack(
                  children: List.generate(sortedButtons.length, (index) {
                    final button = sortedButtons[index];

                    // Coordinate math for the grid position
                    final int row = index ~/ crossAxisCount;
                    final int col = index % crossAxisCount;

                    final double left = col * (itemWidth + spacing);
                    final double top = row * (itemHeight + spacing);

                    // AnimatedPositioned makes the item slide to its new
                    // coordinates instead of jumping instantly.
                    return AnimatedPositioned(
                      // Using the unique route name as a key is critical so
                      // Flutter knows it's the same widget moving.
                      key: ValueKey('anim_module_${button.route.name}'),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOutCubic,
                      left: left,
                      top: top,
                      width: itemWidth,
                      height: itemHeight,
                      child: RepaintBoundary(
                        // RepaintBoundary keeps the paint logic efficient during movement
                        child: button,
                      ),
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
