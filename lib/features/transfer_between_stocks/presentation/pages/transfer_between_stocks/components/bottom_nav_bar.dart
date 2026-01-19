import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

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

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return BottomNavigationBar(
      currentIndex: selectedPageIndex,
      onTap: (index) {
        ref
            .read(
              selectedProductUIStateControllerProvider(enterpriseCode).notifier,
            )
            .updateValues(pageIndex: index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(isIOS ? CupertinoIcons.list_bullet : Icons.list),
          label: 'Produtos'.hardcoded,
        ),
        BottomNavigationBarItem(
          icon: Consumer(
            builder: (_, ref, _) {
              final quantityLength = ref.watch(
                lotStateControllerProvider(enterpriseCode).select(
                  (s) => s.value
                      ?.where((e) => e.product.EnterpriseCode == enterpriseCode)
                      .toList()
                      .length,
                ),
              );

              return QuantityBadge(
                quantity: quantityLength,
                materialIcon: Icons.shopping_cart,
                cupertinoIcon: CupertinoIcons.shopping_cart,
                isSelected: selectedPageIndex == 1,
              );
            },
          ),
          label: 'Lote'.hardcoded,
        ),
      ],
    );
  }
}
