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
  final int index;
  final int? selectedIndex;
  final void Function(int?, ProductEntity, CartProductEntity?) onTapProduct;
  final void Function(
    ProductEntity,
    CartProductEntity?,
    PercentageOrValue? discountType,
  )
  insertProduct;
  final RequestTypeEntity selectedRequest;
  final ProductsItems productsItemsWidget;
  const ProductItem({
    super.key,
    required this.product,
    required this.index,
    required this.selectedIndex,
    required this.onTapProduct,
    required this.insertProduct,
    required this.selectedRequest,
    required this.productsItemsWidget,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __ProductItemState();
}

class __ProductItemState extends ConsumerState<ProductItem> {
  PercentageOrValue? discountType;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        setState(() {
          discountType = ref
              .read(
                pendingSaleRequestStateControllerProvider.select(
                  (state) =>
                      state.value?.cart[widget.product.ProductPackingCode],
                ),
              )
              ?.DiscountPercentageOrValue;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProduct = ref.watch(
      pendingSaleRequestStateControllerProvider.select(
        (state) => state.value?.cart[widget.product.ProductPackingCode],
      ),
    );
    return ProductItemWidget(
      product: widget.product,
      routine: BsRoutine.saleRequest,
      showDropIcon: true,
      isSelected: widget.index == widget.selectedIndex,
      onTap: () =>
          widget.onTapProduct(widget.index, widget.product, cartProduct),
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
      notClickableBottom: widget.index == widget.selectedIndex
          ? QuantityPriceDiscountFieldsAndInsertButton(
              insertProduct: () => widget.insertProduct(
                widget.product,
                cartProduct,
                discountType,
              ),
              changeDiscountType: (value) {
                setState(() {
                  discountType = value;
                });
              },
              discountType: discountType,
              quantityController: widget.productsItemsWidget.quantityController,
              priceController: widget.productsItemsWidget.priceController,
              discountController: widget.productsItemsWidget.discountController,
              quantityFocusNode: widget.productsItemsWidget.quantityFocusNode,
              discountFocusNode: widget.productsItemsWidget.discountFocusNode,
              priceFocusNode: widget.productsItemsWidget.priceFocusNode,
              selectedRequest: widget.productsItemsWidget.selectedRequest,
              productPackingCode: widget.product.ProductPackingCode,
            )
          : null,
    );
  }
}
