import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/request_type/request_type.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    SaleRequestCartProductEntity? cartProduct,
  ) async {
    final selectedRequest = await ref.read(
      requestTypeStateControllerProvider(
        Modules.saleRequest,
        widget.enterpriseCode,
      ).selectAsync((s) => s!.firstWhere((x) => x.code == widget.requestCode)),
    );

    if (product.getPrice == 0 &&
        selectedRequest.allowAlterCostOrSalePrice != true) {
      if (!mounted) return;
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
                      (x) => x.code == widget.requestCode,
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
