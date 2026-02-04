import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class ProductItem extends ConsumerWidget {
  final ProductEntity product;
  final TextEditingController retailController;
  final TextEditingController retailOfferController;
  final TextEditingController wholeController;
  final TextEditingController wholeOfferController;
  final TextEditingController ecommerceController;
  final TextEditingController ecommerceOfferController;
  final FocusNode retailFocusNode;
  final FocusNode retailOfferFocusNode;
  final FocusNode wholeFocusNode;
  final FocusNode wholeOfferFocusNode;
  final FocusNode ecommerceFocusNode;
  final FocusNode ecommerceOfferFocusNode;
  final int index;
  final ProductsItems widget;
  const ProductItem({
    super.key,
    required this.product,
    required this.retailController,
    required this.retailOfferController,
    required this.wholeController,
    required this.wholeOfferController,
    required this.ecommerceController,
    required this.ecommerceOfferController,
    required this.retailFocusNode,
    required this.retailOfferFocusNode,
    required this.wholeFocusNode,
    required this.wholeOfferFocusNode,
    required this.ecommerceFocusNode,
    required this.ecommerceOfferFocusNode,
    required this.index,
    required this.widget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(
      selectedItemUIControllerProvider.select((s) => s.selectedIndex == index),
    );
    return RepaintBoundary(
      child: ProductItemWidget(
        product: product,
        routine: BsRoutine.researchOfPrice,
        showDropIcon: true,
        notClickableBottom: isSelected
            ? PricesFieldsAndSubmit(
                product: product,
                retailController: retailController,
                retailOfferController: retailOfferController,
                wholeController: wholeController,
                wholeOfferController: wholeOfferController,
                ecommerceController: ecommerceController,
                ecommerceOfferController: ecommerceOfferController,
                retailFocusNode: retailFocusNode,
                retailOfferFocusNode: retailOfferFocusNode,
                wholeFocusNode: wholeFocusNode,
                wholeOfferFocusNode: wholeOfferFocusNode,
                ecommerceFocusNode: ecommerceFocusNode,
                ecommerceOfferFocusNode: ecommerceOfferFocusNode,
                widget: widget,
              )
            : null,
        onTap: () {
          final selectedItemAsync = ref.read(selectedItemUIControllerProvider);

          ref
              .read(selectedItemUIControllerProvider.notifier)
              .update(selectedItemAsync.copyWith(selectedIndex: index));
          String getNewValue(double? price) {
            return price == null || price == 0
                ? ''
                : price.toStringAsFixed(2).replaceAll(RegExp(r'\.'), ',');
          }

          retailController.text = getNewValue(product.RetailPracticedPrice);
          retailOfferController.text = getNewValue(product.RetailOfferPrice);
          wholeController.text = getNewValue(product.WholePracticedPrice);
          wholeOfferController.text = getNewValue(product.WholeOfferPrice);
          ecommerceController.text = getNewValue(
            product.ECommercePracticedPrice,
          );
          ecommerceOfferController.text = getNewValue(
            product.ECommerceOfferPrice,
          );
        },
        clickableBottom: AppliedPrices(product: product),
        isSelected: ref.watch(
          selectedItemUIControllerProvider.select(
            (s) => s.selectedIndex == index,
          ),
        ),
      ),
    );
  }
}
