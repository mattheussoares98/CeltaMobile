import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/adjust_cost/presentation/pages/components/components.dart';

class ProductsItems extends ConsumerWidget {
  final int enterpriseCode;
  const ProductsItems({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.generic,
      Modules.adjustCost,
    );
    return AsyncValueWidget(
      value: ref.watch(searchProductsStateControllerProvider(searchProductKey)),
      tryAgain: null,
      data: (products) {
        return Expanded(
          child: ResponsiveListFlow(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductItem(
                key: ValueKey(products[index].ProductPackingCode),
                index: index,
                enterpriseCode: enterpriseCode,
              );
            },
          ),
        );
      },
    );
  }
}
