import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';

class CartPriceIcon extends ConsumerWidget {
  const CartPriceIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () =>
          ref.read(uiStateControllerProvider.notifier).updatePageIndex(3),
      child: QuantityBadge(
        quantity: ref.watch(
          pendingBuyRequestStateControllerProvider.select(
            (s) => s.value?.products?.length ?? 0,
          ),
        ),
        materialIcon: Icons.shopping_cart,
        cupertinoIcon: CupertinoIcons.shopping_cart,
        isSelected: false,
        offset: const Offset(3, -3),
        subtitle: Consumer(
          builder: (_, ref, _) {
            final totalPrice = ref.watch(
              pendingBuyRequestStateControllerProvider.select(
                (s) => s.value?.products?.values.fold(
                  0.0,
                  (previousValue, element) =>
                      previousValue + (element.cost * element.quantity),
                ),
              ),
            );

            return Text(
              'R\$ ${(totalPrice ?? 0).toStringAsFixed(2).toBrazilianNumber(2, true)}',
              style: const TextStyle(fontSize: 9),
            );
          },
        ),
      ),
    );
  }
}
