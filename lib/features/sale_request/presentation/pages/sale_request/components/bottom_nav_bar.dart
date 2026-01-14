import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final products = ref.watch(
      pendingSaleRequestStateControllerProvider.select(
        (s) => s.value?.cart.values,
      ),
    );

    final index = ref.watch(pageIndexStateControllerProvider);
    return BottomNavigationBar(
      onTap: ref.read(pageIndexStateControllerProvider.notifier).updateIndex,
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          label: 'Inserir produtos'.hardcoded,
          icon: Icon(
            isIOS ? CupertinoIcons.cart_fill : Icons.add_shopping_cart,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Cliente'.hardcoded,
          icon: ValidatedBadge(
            isSelected: index == 1,
            isValid:
                ref.watch(
                  pendingSaleRequestStateControllerProvider.select(
                    (state) => state.value?.customer,
                  ),
                ) !=
                null,
            materialIcon: Icons.person,
            cupertinoIcon: CupertinoIcons.person,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Carrinho'.hardcoded,
          icon: QuantityBadge(
            quantity: products?.length ?? 0,
            materialIcon: Icons.shopping_cart,
            cupertinoIcon: CupertinoIcons.shopping_cart,
            isSelected: index == 2,
          ),
        ),
      ],
    );
  }
}
