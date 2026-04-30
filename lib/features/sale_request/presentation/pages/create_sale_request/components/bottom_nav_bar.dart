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

    final index = ref.watch(pageIndexStateControllerProvider);
    return BottomNavigationBar(
      onTap: ref.read(pageIndexStateControllerProvider.notifier).updateIndex,
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          label: 'Inserir produtos'.hardcoded,
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.cart_fill,
            materialIcon: Icons.add_shopping_cart,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Cliente'.hardcoded,
          icon: Consumer(
            builder: (_, ref, _) {
              return ValidatedBadge(
                isSelected: index == 1,
                isValid:
                    ref.watch(
                      pendingSaleRequestStateControllerProvider(
                        enterpriseCode,
                      ).select((state) => state.value?.customer),
                    ) !=
                    null,
                materialIcon: Icons.person,
                cupertinoIcon: CupertinoIcons.person,
              );
            },
          ),
        ),
        BottomNavigationBarItem(
          label: 'Carrinho'.hardcoded,
          icon: Consumer(
            builder: (_, ref, _) {
              final productsLength = ref.watch(
                pendingSaleRequestStateControllerProvider(
                  enterpriseCode,
                ).select((s) => s.value?.cart.values.length ?? 0),
              );
              return QuantityBadge(
                quantity: productsLength,
                materialIcon: Icons.shopping_cart,
                cupertinoIcon: CupertinoIcons.shopping_cart,
                isSelected: index == 2,
              );
            },
          ),
        ),
      ],
    );
  }
}
