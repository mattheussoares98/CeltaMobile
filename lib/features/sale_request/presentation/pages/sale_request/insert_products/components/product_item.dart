import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import '../../components/components.dart';
import 'components.dart';

class ProductItem extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProduct = ref.watch(
      pendingSaleRequestStateControllerProvider.select(
        (state) => state.value?.cart[product.ProductPackingCode],
      ),
    );
    final selectedPackingCode = ref.watch(
      selectedItemUIControllerProvider(
        isCartPage: false,
      ).select((s) => s.productPackingCode),
    );

    return ProductItemWidget(
      product: product,
      routine: BsRoutine.saleRequest,
      showDropIcon: true,
      isSelected: selectedPackingCode == product.ProductPackingCode,
      onTap: () => onTapProduct(product, cartProduct),
      cartItemSummary: cartProduct == null
          ? null
          : CartItemSummary(
              cartQuantity: cartProduct.Quantity,
              cartValue: cartProduct.Value,
              product: product,
              totalDiscount: cartProduct.DiscountValue,
            ),
      onDelete: cartProduct == null
          ? null
          : () {
              ref
                  .read(pendingSaleRequestStateControllerProvider.notifier)
                  .removeProduct(cartProduct);
            },
      notClickableBottom: selectedPackingCode == product.ProductPackingCode
          ? QuantityPriceDiscountFieldsAndInsertButton(
              isCartPage: false,
              product: product,
              cartProduct: cartProduct,
              quantityController: productsItemsWidget.quantityController,
              priceController: productsItemsWidget.priceController,
              discountController: productsItemsWidget.discountController,
              quantityFocusNode: productsItemsWidget.quantityFocusNode,
              discountFocusNode: productsItemsWidget.discountFocusNode,
              priceFocusNode: productsItemsWidget.priceFocusNode,
              selectedRequest: productsItemsWidget.selectedRequest,
            )
          : null,
    );
  }
}
