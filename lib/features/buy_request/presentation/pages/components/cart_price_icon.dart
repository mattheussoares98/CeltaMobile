import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../../constants/constants.dart';
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

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Badge(
            label: Text(
              (pendingAsync.value?.products?.values.length ?? 0).toString(),
            ),
            child: Icon(
              isIOS ? CupertinoIcons.shopping_cart : Icons.shopping_cart,
              color: theme.disabledColor,
              size: Sizes.p24,
            ),
          ),
          Text(
            'R\$ ${totalPrice.toStringAsFixed(2).toBrazilianNumber(2, true)}',
            style: TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
  }
}
