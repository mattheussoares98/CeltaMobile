import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import '../../components/components.dart';
import 'components.dart';

class ProductItem extends ConsumerStatefulWidget {
  final ProductEntity product;
  final void Function(ProductEntity, CartProductEntity?) onTapProduct;
  final RequestTypeEntity selectedRequest;
  final ProductsItems productsItemsWidget;
  const ProductItem({
    super.key,
    required this.product,
    required this.onTapProduct,
    required this.selectedRequest,
    required this.productsItemsWidget,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __ProductItemState();
}

class __ProductItemState extends ConsumerState<ProductItem> {
  //TODO change to stateless
  @override
  Widget build(BuildContext context) {
    final cartProduct = ref.watch(
      pendingSaleRequestStateControllerProvider.select(
        (state) => state.value?.cart[widget.product.ProductPackingCode],
      ),
    );
    final selectedPackingCode = ref.watch(
      selectedItemUIControllerProvider(
        isCartPage: false,
      ).select((s) => s.productPackingCode),
    );

    return ProductItemWidget(
      product: widget.product,
      routine: BsRoutine.saleRequest,
      showDropIcon: true,
      isSelected: selectedPackingCode == widget.product.ProductPackingCode,
      onTap: () => widget.onTapProduct(widget.product, cartProduct),
      cartItemSummary: cartProduct == null
          ? null
          : CartItemSummary(
              cartQuantity: cartProduct.Quantity,
              cartValue: cartProduct.Value,
              product: widget.product,
              totalDiscount: cartProduct.DiscountValue,
            ),
      onDelete: cartProduct == null
          ? null
          : () {
              ref
                  .read(pendingSaleRequestStateControllerProvider.notifier)
                  .removeProduct(cartProduct);
            },
      notClickableBottom:
          selectedPackingCode == widget.product.ProductPackingCode
          ? QuantityPriceDiscountFieldsAndInsertButton(
              isCartPage: false,
              product: widget.product,
              cartProduct: cartProduct,
              quantityController: widget.productsItemsWidget.quantityController,
              priceController: widget.productsItemsWidget.priceController,
              discountController: widget.productsItemsWidget.discountController,
              quantityFocusNode: widget.productsItemsWidget.quantityFocusNode,
              discountFocusNode: widget.productsItemsWidget.discountFocusNode,
              priceFocusNode: widget.productsItemsWidget.priceFocusNode,
              selectedRequest: widget.productsItemsWidget.selectedRequest,
            )
          : null,
    );
  }
}
