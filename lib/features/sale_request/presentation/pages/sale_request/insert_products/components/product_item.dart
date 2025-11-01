import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class ProductItem extends ConsumerStatefulWidget {
  final ProductEntity product;
  final int index;
  final int? selectedIndex;
  final void Function(int?, ProductEntity, CartProductEntity?) onTapProduct;
  final void Function(ProductEntity, CartProductEntity?) insertProduct;
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
            ),
      onDelete: cartProduct == null
          ? null
          : () {
              ref
                  .read(pendingSaleRequestStateControllerProvider.notifier)
                  .removeProduct(cartProduct);
            },
      notClickableBottom: widget.index == widget.selectedIndex
          ? Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 65,
                      child: Column(
                        children: [
                          QuantityField(
                            productsItems: widget.productsItemsWidget,
                            insertProduct: () => widget.insertProduct(
                              widget.product,
                              cartProduct,
                            ),
                          ),
                          if (widget
                                  .selectedRequest
                                  .AllowAlterCostOrSalePrice ==
                              true) ...[
                            gapH4,
                            PriceField(
                              productsItems: widget.productsItemsWidget,
                              insertProduct: () => widget.insertProduct(
                                widget.product,
                                cartProduct,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    gapW4,
                    Expanded(
                      flex: 35,
                      child: TotalPriceAndInsertButton(
                        insertProduct: () =>
                            widget.insertProduct(widget.product, cartProduct),
                        productsItems: widget.productsItemsWidget,
                        product: widget.product,
                      ),
                    ),
                  ],
                ),
                if (widget.selectedRequest.AllowDiscount == true) ...[
                  gapH4,
                  DiscountFieldAndTypeDropdown(
                    productsItems: widget.productsItemsWidget,
                    insertProduct: () =>
                        widget.insertProduct(widget.product, cartProduct),
                    discountType: discountType,
                    changeDiscountType: (value) {
                      setState(() {
                        discountType = value;
                      });
                    },
                  ),
                ],
              ],
            )
          : null,
    );
  }
}
