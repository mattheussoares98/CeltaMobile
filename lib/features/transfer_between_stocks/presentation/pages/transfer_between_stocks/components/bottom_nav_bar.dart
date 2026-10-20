import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/transfer_between_stocks/presentation/controllers/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavBar extends ConsumerWidget {
  final int enterpriseCode;
  const BottomNavBar({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageIndex = ref.watch(
      selectedProductUIStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.pageIndex),
    );

    final quantityLength = ref.watch(
      lotStateControllerProvider(enterpriseCode).select(
        (s) =>
            s.value
                ?.where((e) => e.product.EnterpriseCode == enterpriseCode)
                .length ??
            0,
      ),
    );

    return BaseBottomNavigationBar(
      currentIndex: selectedPageIndex,
      onTap: (index) {
        ref
            .read(
              selectedProductUIStateControllerProvider(enterpriseCode).notifier,
            )
            .updateValues(pageIndex: index);
      },
      items: [
        BaseBottomNavigationBarItem(
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.list_bullet,
            materialIcon: Icons.list,
          ),
          label: context.l10n.products,
        ),
        BaseBottomNavigationBarItem(
          platformIcon: const PlatformIcon(
            materialIcon: Icons.shopping_cart,
            cupertinoIcon: CupertinoIcons.shopping_cart,
          ),
          badgeLabel: quantityLength > 0 ? quantityLength.toString() : null,
          label: context.l10n.batch,
        ),
      ],
    );
  }
}
