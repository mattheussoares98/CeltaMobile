import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../domain/entities/entities.dart';
import '../../components/components.dart';
import 'components.dart';

class ProductItem extends ConsumerStatefulWidget {
  final CartProductEntity product;
  final VoidCallback onTap;
  final bool isSelected;
  final void Function(
    CartProductEntity product,
    PercentageOrValue? discountType,
  )
  updateProduct;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final FocusNode quantityFocusNode;
  final FocusNode discountFocusNode;
  final FocusNode priceFocusNode;
  final RequestTypeEntity selectedRequest;
  const ProductItem({
    super.key,
    required this.product,
    required this.onTap,
    required this.isSelected,
    required this.updateProduct,
    required this.quantityController,
    required this.priceController,
    required this.discountController,
    required this.quantityFocusNode,
    required this.discountFocusNode,
    required this.priceFocusNode,
    required this.selectedRequest,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductItemState();
}

class _ProductItemState extends ConsumerState<ProductItem> {
  PercentageOrValue? discountType;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        discountType = widget.product.DiscountPercentageOrValue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  NamePluAndDeleteButton(product: widget.product),
                  gapH4,
                  Values(
                    product: widget.product,
                    isSelected: widget.isSelected,
                  ),
                ],
              ),
            ),
          ),
          if (widget.isSelected)
            Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Form(
                key: formKey,
                child: QuantityPriceDiscountFieldsAndInsertButton(
                  insertProduct: () =>
                      widget.updateProduct(widget.product, discountType),
                  quantityController: widget.quantityController,
                  priceController: widget.priceController,
                  discountController: widget.discountController,
                  quantityFocusNode: widget.quantityFocusNode,
                  discountFocusNode: widget.discountFocusNode,
                  priceFocusNode: widget.priceFocusNode,
                  selectedRequest: widget.selectedRequest,
                  productPackingCode: widget.product.ProductPackingCode,
                  discountType: discountType,
                  changeDiscountType: (value) {
                    setState(() {
                      discountType = value;
                    });
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
