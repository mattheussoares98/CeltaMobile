import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/controllers.dart';
import 'components.dart';

class PendingProductsItems extends ConsumerWidget {
  final int expeditionControlCode;
  const PendingProductsItems({super.key, required this.expeditionControlCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref
        .watch(expeditionConferenceControllerProvider(expeditionControlCode))
        .value
        ?.pendingProducts;

    return ListView.builder(
      itemCount: products?.length ?? 0,
      itemBuilder: (_, index) {
        final product = products![index];
        return ProductItem(product: product);
      },
    );
  }
}
