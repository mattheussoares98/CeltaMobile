import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';

class CartPriceIcon extends ConsumerWidget {
  const CartPriceIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(
      pendingBuyRequestStateControllerProvider.select(
        (s) => s.value?.products ?? {},
      ),
    );
    final totalPrice = products.values.fold(
      0.0,
      (previousValue, element) =>
          previousValue + (element.cost * element.quantity),
    );

    return GestureDetector(
      onTap: () =>
          ref.read(uiStateControllerProvider.notifier).updatePageIndex(3),
      child: QuantityBadge(
        quantity: products.values.length,
        materialIcon: Icons.shopping_cart,
        cupertinoIcon: CupertinoIcons.shopping_cart,
        isSelected: false,
        offset: const Offset(3, -3),
        subtitle: Text(
          'R\$ ${totalPrice.toStringAsFixed(2).toBrazilianNumber(2, true)}',
          style: const TextStyle(fontSize: 9),
        ),
      ),
    );
  }
}
