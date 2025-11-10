import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import '../../components/components.dart';
import 'components.dart';

class ProductItem extends ConsumerWidget {
  final CartProductEntity cartProduct;
  final VoidCallback onTap;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final FocusNode quantityFocusNode;
  final FocusNode discountFocusNode;
  final FocusNode priceFocusNode;
  final RequestTypeEntity selectedRequest;
  const ProductItem({
    super.key,
    required this.cartProduct,
    required this.onTap,
    required this.quantityController,
    required this.priceController,
    required this.discountController,
    required this.quantityFocusNode,
    required this.discountFocusNode,
    required this.priceFocusNode,
    required this.selectedRequest,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected =
        ref.watch(
          selectedItemUIControllerProvider(
            isCartPage: true,
          ).select((s) => s.productPackingCode),
        ) ==
        cartProduct.ProductPackingCode;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.p4),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p8,
                Sizes.p8,
                0,
                Sizes.p8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NamePluAndDeleteButton(cartProduct: cartProduct),
                  gapH4,
                  if (cartProduct.DiscountDescription != null)
                    TitleAndSubTitle(
                      title: null,
                      subTitle: cartProduct.DiscountDescription,
                      subTitleStyle: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  Values(product: cartProduct, isSelected: isSelected),
                ],
              ),
            ),
          ),
          if (isSelected) ...[
            BsPricesAndMinimumWholeQuantity(cartProduct: cartProduct),
            Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: QuantityPriceDiscountFieldsAndInsertButton(
                cartProduct: cartProduct,
                isCartPage: true,
                quantityController: quantityController,
                priceController: priceController,
                discountController: discountController,
                quantityFocusNode: quantityFocusNode,
                discountFocusNode: discountFocusNode,
                priceFocusNode: priceFocusNode,
                selectedRequest: selectedRequest,
                product: cartProduct.product!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
