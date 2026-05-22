import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';

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
            .read(
              uiStateControllerProvider(
                requestTypeCode,
                draftKey.enterpriseOrigin,
              ).notifier,
            )
            .updatePageIndex(1);
      },
      child: QuantityBadge(
        quantity: productsQuantity,
        platformIcon: const PlatformIcon(
          materialIcon: Icons.shopping_cart,
          cupertinoIcon: CupertinoIcons.shopping_cart,
        ),
        isSelected: false,
        totalPrice: totalPrice,
      ),
    );
  }
}
