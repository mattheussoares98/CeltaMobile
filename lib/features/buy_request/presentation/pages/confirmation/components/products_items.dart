import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../utils/utils.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class ProductsItems extends ConsumerWidget {
  final GlobalKey<FormState> fieldsFormKey;
  final GlobalKey<FormState> quantityFormKey;
  final TextEditingController quantityController;
  final TextEditingController costController;
  final FocusNode quantityFocusNode;
  final FocusNode costFocusNode;
  final ProductEntity product;
  final bool isConfirmationPage;
  const ProductsItems({
    super.key,
    required this.fieldsFormKey,
    required this.quantityFormKey,
    required this.quantityController,
    required this.costController,
    required this.quantityFocusNode,
    required this.costFocusNode,
    required this.product,
    required this.isConfirmationPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onDelete(ProductEntity product, PendingBuyRequestEntity? pending) {
      final products = pending?.products;
      products?.removeWhere((key, value) {
        return key ==
            ProductKey(
              enterpriseCode: product.EnterpriseCode!,
              productPackingCode: product.ProductPackingCode!,
            );
      });

      ref
          .read(pendingBuyRequestStateControllerProvider.notifier)
          .updatePending(pending!.copyWith(products: products));
    }

    final selectedIndex = ref.watch(
      uiStateControllerProvider.select(
        (s) => s.value?.selectedCartProductIndex,
      ),
    );

    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);
    return SliverList.builder(
      itemCount: pendingAsync.value?.products?.length ?? 0,
      itemBuilder: (_, index) {
        final product = pendingAsync.value?.products?.values.toList()[index];
        return ProductItemWidget(
          product: product!.product,
          routine: BsRoutine.buyRequest,
          hideCost: true,
          hideCurrentAndSaleStocks: true,
          hideWholeInformations: true,
          showDropIcon: true,
          showInfoButton: false,
          isSelected: selectedIndex == index,
          onTap: () {
            quantityFocusNode.requestFocus();
            costController.text = product.cost
                .toString()
                .toBrazilianNumber(4)
                .replaceAll(RegExp(r'\.'), '');
            quantityController.text = product.quantity
                .toString()
                .toBrazilianNumber(3, true)
                .replaceAll(RegExp(r'\.'), '');
            quantityController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: quantityController.text.length,
            );
            ref
                .read(uiStateControllerProvider.notifier)
                .updateSelectedCartProductIndex(index);
          },
          cartItemSummary: CartItemSummary(
            cartQuantity: product.quantity,
            cartValue: product.cost,
            product: product.product,
          ),
          onDelete: () => onDelete(product.product, pendingAsync.value),
          itemBeforeProductName: EnterpriseCodeAndProductName(
            product: product.product,
          ),
          notClickableBottom: selectedIndex == index
              ? FieldsAndConfirm(
                  isConfirmationPage: true,
                  fieldsFormKey: fieldsFormKey,
                  quantityFormKey: quantityFormKey,
                  quantityController: quantityController,
                  costController: costController,
                  quantityFocusNode: quantityFocusNode,
                  costFocusNode: costFocusNode,
                  product: product.product,
                )
              : null,
        );
      },
    );
  }
}
