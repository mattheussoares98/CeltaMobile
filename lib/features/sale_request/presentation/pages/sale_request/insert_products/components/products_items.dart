import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';
import 'components.dart';

class ProductsItems extends ConsumerWidget {
  final int enterpriseCode;
  final int requestCode;
  const ProductsItems({
    super.key,
    required this.enterpriseCode,
    required this.requestCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(
        searchProductsStateControllerProvider(
          SearchProductKey(
            enterpriseCode,
            BsRoutine.saleRequest,
            Modules.saleRequest,
          ),
        ),
      ),
      tryAgain: null,
      data: (products) {
        return ResponsiveListFlow(
          itemCount: products.length,
          itemBuilder: (_, index) {
            final product = products[index];

            return ProductItem(
              key: ValueKey(
                '${product.ProductPackingCode}${product.EnterpriseCode}',
              ),
              product: product,
              requestCode: requestCode,
              enterpriseCode: enterpriseCode,
            );
          },
        );
      },
    );
  }
}
