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
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        descendantsAreTraversable: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BsPricesAndMinimumWholeQuantity(widget: widget),
            gapH8,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 65,
                  child: Column(
                    children: [
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(1),
                        child: QuantityField(
                          insertProduct: insertUpdateProduct,
                          widget: widget,
                        ),
                      ),
                      if (widget.selectedRequest.AllowAlterCostOrSalePrice ==
                          true) ...[
                        gapH4,
                        FocusTraversalOrder(
                          order: const NumericFocusOrder(2),
                          child: PriceField(
                            //TODO cant insert the price if the discount is settled
                            insertProduct: insertUpdateProduct,
                            widget: widget,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                gapW4,
                Expanded(
                  flex: 35,
                  child: FocusTraversalOrder(
                    order: const NumericFocusOrder(4),
                    child: TotalPriceAndInsertButton(
                      insertProduct: insertUpdateProduct,
                      widget: widget,
                    ),
                  ),
                ),
              ],
            ),
            if (widget.selectedRequest.AllowDiscount == true) ...[
              gapH4,
              FocusTraversalOrder(
                order: const NumericFocusOrder(3),
                child: DiscountFieldAndTypeDropdown(
                  //TODO cant insert the discount if the price is settled
                  insertProduct: insertUpdateProduct,
                  widget: widget,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
