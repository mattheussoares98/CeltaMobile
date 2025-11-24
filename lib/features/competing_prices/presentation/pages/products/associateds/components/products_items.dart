import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';

class ProductsItems extends ConsumerWidget {
  final int enterpriseCode;
  const ProductsItems({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(
        searchProductsStateControllerProvider(
          enterpriseCode,
          BsRoutine.researchOfPrice,
          Modules.competingPrices,
        ),
      ),
      tryAgain: null,
      data: (products) {
        return Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];

              return Text(product.Name!);
            },
          ),
        );
      },
    );
  }
}
