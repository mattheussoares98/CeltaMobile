import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarActions extends ConsumerWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (_, ref, _) {
        //!if there are changes, I can't calculate exactly the price. Because of
        //!this, I show the sent total price by BS when there are no changes
        final hasChanges = ref.watch(saleRequestHasChangesProvider);

        final (int quantity, double totalPrice) = ref.watch(
          insertUpdateStateControllerProvider.select(
            (s) => (
              s.value?.products?.length ?? 0,
              hasChanges
                  ? s.value?.currentSaleRequestLiquid ?? 0
                  : s.value?.totalLiquid ?? 0,
            ),
          ),
        );
        return QuantityBadge(
          quantity: quantity,
          totalPrice: totalPrice,
          platformIcon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.cart,
            materialIcon: Icons.shopping_cart,
          ),
          isSelected: false,
        );
      },
    );
  }
}
