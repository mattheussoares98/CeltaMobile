import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/pages/products/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingProductsItems extends ConsumerWidget {
  final int expeditionControlCode;
  const PendingProductsItems({super.key, required this.expeditionControlCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingProducts = ref.watch(
      expeditionConferenceControllerProvider(
        expeditionControlCode,
      ).select((s) => s.value?.pendingProducts),
    );
    return CustomScrollView(
      slivers: [
        ResponsiveListFlow(
          isSliver: true,
          itemCount: pendingProducts?.length ?? 0,
          itemBuilder: (_, index) {
            final product = pendingProducts![index];
            return ProductItem(
              key: ValueKey(product.ProductPackingCode),
              product: product,
              expeditionControlCode: expeditionControlCode,
              isPending: true,
            );
          },
        ),
      ],
    );
  }
}
