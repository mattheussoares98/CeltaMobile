import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/create_sale_request/insert_products/components/components.dart';

class ProductsItems extends ConsumerWidget {
  final SearchProductKey searchProductKey;
  const ProductsItems({super.key, required this.searchProductKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(searchProductsStateControllerProvider(searchProductKey)),
      tryAgain: null,
      data: (products) {
        return ResponsiveListFlow(
          isSliver: true,
          itemCount: products.length,
          itemBuilder: (_, index) {
            final product = products[index];

            return ProductItem(
              key: ValueKey(
                '${product.ProductPackingCode}${product.EnterpriseCode}',
              ),
              product: product,
              requestCode: int.parse(searchProductKey.anotherKey!),
              enterpriseCode: searchProductKey.enterpriseCode,
            );
          },
        );
      },
    );
  }
}
