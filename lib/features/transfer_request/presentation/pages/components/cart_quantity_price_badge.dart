import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../utils/utils.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class CartQuantityPriceBadge extends ConsumerWidget {
  final int requestTypeCode;
  final DraftKey draftKey;
  const CartQuantityPriceBadge({
    super.key,
    required this.requestTypeCode,
    required this.draftKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsQuantity = ref.watch(
      cartProductsStateControllerProvider(
        draftKey,
      ).select((s) => s.value?.length ?? 0),
    );
    final totalPrice = ref.watch(
      cartProductsStateControllerProvider(draftKey).select(
        (s) => s.value?.fold(0.0, (p, e) => p + (e.value * e.quantity)) ?? 0.0,
      ),
    );

    return GestureDetector(
      onTap: () {
        ref
            .read(uiStateControllerProvider(requestTypeCode).notifier)
            .updatePageIndex(1);
      },
      child: QuantityBadge(
        quantity: productsQuantity,
        materialIcon: Icons.shopping_cart,
        cupertinoIcon: CupertinoIcons.shopping_cart,
        isSelected: false,
        offset: const Offset(3, -3),
        //TODO pass a String as param and receive a optional param indicating that the subtitle is a price
        subtitle: Text(
          'R\$ ${totalPrice.toStringAsFixed(2).toBrazilianNumber(2, true)}',
          style: const TextStyle(fontSize: 9),
        ),
      ),
    );
  }
}
