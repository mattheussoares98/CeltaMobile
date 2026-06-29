import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavBar extends ConsumerWidget {
  final int enterpriseCode;
  const BottomNavBar({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(pageIndexStateControllerProvider);

    final isCustomerValid = ref.watch(
      pendingSaleRequestStateControllerProvider(
        enterpriseCode,
      ).select((state) => state.value?.customer != null),
    );

    final productsLength = ref.watch(
      pendingSaleRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.cart.length ?? 0),
    );

    return BaseBottomNavigationBar(
      onTap: ref.read(pageIndexStateControllerProvider.notifier).updateIndex,
      currentIndex: index,
      items: [
        BaseBottomNavigationBarItem(
          label: 'Inserir produtos'.hardcoded,
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.cart_fill,
            materialIcon: Icons.add_shopping_cart,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Cliente'.hardcoded,
          isValid: isCustomerValid,
          platformIcon: const PlatformIcon(
            materialIcon: Icons.person,
            cupertinoIcon: CupertinoIcons.person,
          ),
        ),
        BaseBottomNavigationBarItem(
          label: 'Carrinho'.hardcoded,
          badgeLabel: productsLength > 0 ? productsLength.toString() : null,
          platformIcon: const PlatformIcon(
            materialIcon: Icons.shopping_cart,
            cupertinoIcon: CupertinoIcons.shopping_cart,
          ),
        ),
      ],
    );
  }
}
