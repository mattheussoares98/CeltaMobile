import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/competing_prices/presentation/pages/products/components/components.dart';

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
  final int enterpriseCode;
  final int researchCode;
  final int concurrentCode;
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
    required this.enterpriseCode,
    required this.researchCode,
    required this.concurrentCode,
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
                enterpriseCode: enterpriseCode,
                researchCode: researchCode,
                concurrentCode: concurrentCode,
              )
            : null,
        onTap: () {
          ref
              .read(selectedItemUIControllerProvider.notifier)
              .updateSelectedIndex(index);
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
