import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';

class CartBadge extends ConsumerWidget {
  final int enterpriseCode;
  const CartBadge({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(
      pendingSaleRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.cart.values),
    );
    final totalPrice =
        products?.fold<double>(0.0, (p, e) => p + e.TotalLiquid) ?? 0.0;
    return QuantityBadge(
      quantity: products?.length ?? 0,
      materialIcon: Icons.shopping_cart,
      cupertinoIcon: CupertinoIcons.shopping_cart,
      isSelected: false,
      offset: const Offset(3, -3),
      subtitle: Text(
        totalPrice.toString().toBrazilianNumber().addBrazilianCoin(),
        style: const TextStyle(fontSize: 9),
      ),
    );
  }
}
