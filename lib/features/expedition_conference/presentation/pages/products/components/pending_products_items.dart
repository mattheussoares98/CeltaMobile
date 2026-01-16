import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

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
    return ResponsiveListFlow(
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
    );
  }
}
