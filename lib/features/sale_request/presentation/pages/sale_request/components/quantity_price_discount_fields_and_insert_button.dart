import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class QuantityPriceDiscountFieldsAndInsertButton
    extends ConsumerStatefulWidget {
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final FocusNode quantityFocusNode;
  final FocusNode discountFocusNode;
  final FocusNode priceFocusNode;
  final RequestTypeEntity selectedRequest;
  final ProductEntity product;
  final CartProductEntity? cartProduct;
  final bool isCartPage;

  const QuantityPriceDiscountFieldsAndInsertButton({
    super.key,
    required this.quantityController,
    required this.priceController,
    required this.discountController,
    required this.quantityFocusNode,
    required this.discountFocusNode,
    required this.priceFocusNode,
    required this.selectedRequest,
    required this.product,
    required this.cartProduct,
    required this.isCartPage,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuantityPriceDiscountFieldsAndInsertButtonState();
}

class _QuantityPriceDiscountFieldsAndInsertButtonState
    extends ConsumerState<QuantityPriceDiscountFieldsAndInsertButton> {
  final formKey = GlobalKey<FormState>();

  void insertUpdateProduct() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    double quantity = widget.quantityController.text.toDouble() ?? 0;
    double? discount = widget.discountController.text.toDouble();

    double price =
        widget.priceController.text.toDouble() ?? widget.product.getPrice;
    final discountType = ref.read(
      selectedItemUIControllerProvider(
        isCartPage: widget.isCartPage,
      ).select((state) => state.discountType),
    );

    final updated = await ref
        .read(pendingSaleRequestStateControllerProvider.notifier)
        .addProduct(
          CartProductEntity.create(
            quantity: quantity,
            price: price,
            discountByItem: discount,
            discountType: discountType,
            product: widget.product,
          ),
        );

    if (!updated) return;

    widget.quantityController.clear();
    widget.discountController.clear();
    ref
        .read(
          selectedItemUIControllerProvider(
            isCartPage: widget.isCartPage,
          ).notifier,
        )
        .selectProduct(null, null);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 65,
                child: Column(
                  children: [
                    QuantityField(
                      insertProduct: insertUpdateProduct,
                      quantityController: widget.quantityController,
                      quantityFocusNode: widget.quantityFocusNode,
                      priceFocusNode: widget.priceFocusNode,
                      selectedRequest: widget.selectedRequest,
                    ),
                    if (widget.selectedRequest.AllowAlterCostOrSalePrice ==
                        true) ...[
                      gapH4,
                      PriceField(
                        isCartPage: widget.isCartPage,
                        cartProduct: widget.cartProduct,
                        product: widget.product,
                        insertProduct: insertUpdateProduct,
                        quantityController: widget.quantityController,
                        priceController: widget.priceController,
                        discountFocusNode: widget.discountFocusNode,
                        priceFocusNode: widget.priceFocusNode,
                        selectedRequest: widget.selectedRequest,
                      ),
                    ],
                  ],
                ),
              ),
              gapW4,
              Expanded(
                flex: 35,
                child: TotalPriceAndInsertButton(
                  insertProduct: insertUpdateProduct,
                  priceController: widget.priceController,
                  quantityController: widget.quantityController,
                  discountController: widget.discountController,
                  product: widget.product,
                  isCartPage: widget.isCartPage,
                ),
              ),
            ],
          ),
          if (widget.selectedRequest.AllowDiscount == true) ...[
            gapH4,
            DiscountFieldAndTypeDropdown(
              insertProduct: insertUpdateProduct,
              cartProduct: widget.cartProduct,
              discountController: widget.discountController,
              discountFocusNode: widget.discountFocusNode,
              isCartPage: widget.isCartPage,
            ),
          ],
        ],
      ),
    );
  }
}
