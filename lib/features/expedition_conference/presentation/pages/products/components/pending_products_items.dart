import 'package:flutter/material.dart';

import '../../../../domain/entities/entities.dart';
import 'components.dart';

class PendingProductsItems extends StatelessWidget {
  final List<ExpeditionProductEntity> products;
  const PendingProductsItems({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];
        return ProductItem(product: product);
      },
    );
  }
}
