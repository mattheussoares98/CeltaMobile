import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../domain/entities/entities.dart';

class CartPriceIcon extends StatelessWidget {
  final VoidCallback onTap;
  final AsyncValue<PendingBuyRequestEntity> pendingAsync;
  const CartPriceIcon({
    super.key,
    required this.onTap,
    required this.pendingAsync,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice =
        pendingAsync.value?.products?.values.fold(
          0.0,
          (previousValue, element) =>
              previousValue + (element.cost * element.quantity),
        ) ??
        0.0;

    return QuantityBadge(
      quantity: pendingAsync.value?.products?.values.length,
      materialIcon: Icons.shopping_cart,
      cupertinoIcon: CupertinoIcons.shopping_cart,
      isSelected: false,
      offset: const Offset(3, -3),
      subtitle: Text(
        'R\$ ${totalPrice.toStringAsFixed(2).toBrazilianNumber(2, true)}',
        style: const TextStyle(fontSize: 9),
      ),
    );
  }
}
