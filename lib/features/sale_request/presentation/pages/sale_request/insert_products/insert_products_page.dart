import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import 'components/components.dart';

class InsertProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  final TextEditingController searchProductsController;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final int? selectedProductIndex;
  final void Function(int? index, ProductEntity product) onTapProduct;
  final VoidCallback removeSelectedIndex;
  const InsertProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.searchProductsController,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.selectedProductIndex,
    required this.onTapProduct,
    required this.removeSelectedIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        children: [
          SearchProducts(
            enterpriseCode: enterpriseCode,
            searchProductsController: searchProductsController,
          ),
          gapH8,
          Expanded(
            child: ProductsItems(
              enterpriseCode: enterpriseCode,
              selectedProductIndex: selectedProductIndex,
              onTapProduct: onTapProduct,
              quantityController: quantityController,
              quantityFocusNode: quantityFocusNode,
              removeSelectedIndex: removeSelectedIndex,
            ),
          ),
        ],
      ),
    );
  }
}
