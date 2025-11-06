import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import '../../components/components.dart';
import 'components.dart';

class ProductItem extends ConsumerStatefulWidget {
  final CartProductEntity cartProduct;
  final VoidCallback onTap;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final FocusNode quantityFocusNode;
  final FocusNode discountFocusNode;
  final FocusNode priceFocusNode;
  final RequestTypeEntity selectedRequest;
  final GlobalKey<FormState> formKey;
  const ProductItem({
    super.key,
    required this.cartProduct,
    required this.onTap,
    required this.quantityController,
    required this.priceController,
    required this.discountController,
    required this.quantityFocusNode,
    required this.discountFocusNode,
    required this.priceFocusNode,
    required this.selectedRequest,
    required this.formKey,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductItemState();
}

class _ProductItemState extends ConsumerState<ProductItem> {
  //TODO change to stateless

  @override
  Widget build(BuildContext context) {
    final isSelected =
        ref.watch(
          selectedItemUIControllerProvider(
            isCartPage: true,
          ).select((s) => s.productPackingCode),
        ) ==
        widget.cartProduct.ProductPackingCode;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p8,
                Sizes.p8,
                0,
                Sizes.p8,
              ),
              child: Column(
                children: [
                  NamePluAndDeleteButton(cartProduct: widget.cartProduct),
                  gapH4,
                  Values(product: widget.cartProduct, isSelected: isSelected),
                ],
              ),
            ),
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Form(
                key: widget.formKey,
                child: QuantityPriceDiscountFieldsAndInsertButton(
                  cartProduct: widget.cartProduct,
                  isCartPage: true,
                  quantityController: widget.quantityController,
                  priceController: widget.priceController,
                  discountController: widget.discountController,
                  quantityFocusNode: widget.quantityFocusNode,
                  discountFocusNode: widget.discountFocusNode,
                  priceFocusNode: widget.priceFocusNode,
                  selectedRequest: widget.selectedRequest,
                  product: widget.cartProduct.product!,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
