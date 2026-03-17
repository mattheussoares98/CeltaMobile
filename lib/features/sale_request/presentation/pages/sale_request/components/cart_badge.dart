import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../controllers/controllers.dart';

class CartBadge extends ConsumerWidget {
  final int enterpriseCode;
  const CartBadge({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsLength = ref.watch(
      saleRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.cart.values.length ?? 0),
    );
    final totalPrice = ref.watch(
      saleRequestStateControllerProvider(enterpriseCode).select(
        (s) =>
            s.value?.cart.values.fold<double>(
              0.0,
              (p, e) => p + e.TotalLiquid,
            ) ??
            0.0,
      ),
    );

    return QuantityBadge(
      quantity: productsLength,
      materialIcon: Icons.shopping_cart,
      cupertinoIcon: CupertinoIcons.shopping_cart,
      isSelected: false,
      totalPrice: totalPrice,
    );
  }
}
