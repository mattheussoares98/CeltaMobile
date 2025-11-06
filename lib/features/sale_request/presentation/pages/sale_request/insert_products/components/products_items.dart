import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../domain/entities/entities.dart';
import 'components.dart';

class ProductsItems extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final void Function(ProductEntity product, CartProductEntity? cartProduct)
  onTapProduct;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final FocusNode quantityFocusNode;
  final FocusNode priceFocusNode;
  final FocusNode discountFocusNode;
  final RequestTypeEntity selectedRequest;
  const ProductsItems({
    super.key,
    required this.enterpriseCode,
    required this.onTapProduct,
    required this.quantityController,
    required this.priceController,
    required this.discountController,
    required this.quantityFocusNode,
    required this.priceFocusNode,
    required this.discountFocusNode,
    required this.selectedRequest,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends ConsumerState<ProductsItems> {
  @override
  Widget build(BuildContext context) {
    return AsyncValueWidget(
      value: ref.watch(
        searchProductsStateControllerProvider(
          widget.enterpriseCode,
          BsRoutine.saleRequest,
          Modules.saleRequest,
        ),
      ),
      tryAgain: null,
      data: (products) {
        return ResponsiveListFlow(
          itemCount: products.length,
          itemBuilder: (_, index) {
            final product = products[index];

            return ProductItem(
              product: product,
              onTapProduct: widget.onTapProduct,
              selectedRequest: widget.selectedRequest,
              productsItemsWidget: widget,
            );
          },
        );
      },
    );
  }
}
