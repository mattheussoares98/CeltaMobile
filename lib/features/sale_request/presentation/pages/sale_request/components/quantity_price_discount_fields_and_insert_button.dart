import 'package:flutter/material.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../domain/entities/entities.dart';
import 'components.dart';

class QuantityPriceDiscountFieldsAndInsertButton extends StatelessWidget {
  final VoidCallback insertProduct;
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
    required this.insertProduct,
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 65,
              child: Column(
                children: [
                  QuantityField(
                    insertProduct: insertProduct,
                    quantityController: quantityController,
                    quantityFocusNode: quantityFocusNode,
                    priceFocusNode: priceFocusNode,
                    selectedRequest: selectedRequest,
                  ),
                  if (selectedRequest.AllowAlterCostOrSalePrice == true) ...[
                    gapH4,
                    PriceField(
                      isCartPage: isCartPage,
                      cartProduct: cartProduct,
                      product: product,
                      insertProduct: insertProduct,
                      quantityController: quantityController,
                      priceController: priceController,
                      discountFocusNode: discountFocusNode,
                      priceFocusNode: priceFocusNode,
                      selectedRequest: selectedRequest,
                    ),
                  ],
                ],
              ),
            ),
            gapW4,
            Expanded(
              flex: 35,
              child: TotalPriceAndInsertButton(
                insertProduct: insertProduct,
                priceController: priceController,
                quantityController: quantityController,
                discountController: discountController,
                product: product,
                isCartPage: isCartPage,
              ),
            ),
          ],
        ),
        if (selectedRequest.AllowDiscount == true) ...[
          gapH4,
          DiscountFieldAndTypeDropdown(
            insertProduct: insertProduct,
            cartProduct: cartProduct,
            discountController: discountController,
            discountFocusNode: discountFocusNode,
            isCartPage: isCartPage,
          ),
        ],
      ],
    );
  }
}
