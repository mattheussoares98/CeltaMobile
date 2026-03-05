import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import '../../components/components.dart';

class ProductItem extends ConsumerStatefulWidget {
  final ProductEntity product;
  final int requestCode;
  final int enterpriseCode;
  const ProductItem({
    super.key,
    required this.product,
    required this.requestCode,
    required this.enterpriseCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductItemState();
}

class _ProductItemState extends ConsumerState<ProductItem> {
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final discountFocusNode = FocusNode();
  final priceFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    quantityController.dispose();
    priceController.dispose();
    quantityFocusNode.dispose();
    discountFocusNode.dispose();
    priceFocusNode.dispose();
  }

  void onTapProduct(
    ProductEntity product,
    CartProductEntity? cartProduct,
  ) async {
    final selectedRequest = await ref.read(
      requestTypeStateControllerProvider(
        Modules.saleRequest,
        widget.enterpriseCode,
      ).selectAsync((s) => s!.firstWhere((x) => x.Code == widget.requestCode)),
    );

    if (product.getPrice == 0 &&
        selectedRequest.AllowAlterCostOrSalePrice != true) {
      showSnackBarMessage(
        context,
        'Esse produto está com o preço zerado e o modelo não permite alterar o preço'
            .hardcoded,
        backgroundColor: Colors.red,
      );
      return;
    }
    ref
        .read(selectedItemUIControllerProvider(isCartPage: false).notifier)
        .selectProduct(product.ProductPackingCode, cartProduct);

    if (ref
            .read(selectedItemUIControllerProvider(isCartPage: false))
            .productPackingCode ==
        null) {
      //selected item is null
      return;
    }

    priceController.clear();
    discountController.clear();

    if ((cartProduct?.Quantity ?? 0) > 0) {
      quantityController.text = cartProduct!.Quantity.toString().replaceAll(
        RegExp(r'\.'),
        ',',
      );
    } else {
      quantityController.text = '1';
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      quantityFocusNode.requestFocus();
      quantityController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: quantityController.text.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProduct = ref.watch(
      pendingSaleRequestStateControllerProvider(
        widget.enterpriseCode,
      ).select((state) => state.value?.cart[widget.product.ProductPackingCode]),
    );
    final isSelected = ref.watch(
      selectedItemUIControllerProvider(isCartPage: false).select(
        (s) => s.productPackingCode == widget.product.ProductPackingCode,
      ),
    );

    return ProductItemWidget(
      product: widget.product,
      routine: BsRoutine.saleRequest,
      showDropIcon: true,
      isSelected: isSelected,
      onTap: () => onTapProduct(widget.product, cartProduct),
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
                  .read(
                    pendingSaleRequestStateControllerProvider(
                      widget.enterpriseCode,
                    ).notifier,
                  )
                  .removeProduct(cartProduct);
            },
      notClickableBottom: isSelected
          ? Consumer(
              builder: (_, ref, _) {
                final selectedRequest = ref.watch(
                  requestTypeStateControllerProvider(
                    Modules.saleRequest,
                    widget.enterpriseCode,
                  ).select(
                    (s) => s.value!.firstWhere(
                      (x) => x.Code == widget.requestCode,
                    ),
                  ),
                );

                return QuantityPriceDiscountFieldsAndInsertButton(
                  isCartPage: false,
                  product: widget.product,
                  cartProduct: cartProduct,
                  quantityController: quantityController,
                  priceController: priceController,
                  discountController: discountController,
                  quantityFocusNode: quantityFocusNode,
                  discountFocusNode: discountFocusNode,
                  priceFocusNode: priceFocusNode,
                  selectedRequest: selectedRequest,
                  enterpriseCode: widget.enterpriseCode,
                );
              },
            )
          : null,
    );
  }
}
