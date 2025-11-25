import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class ProductsItems extends ConsumerWidget {
  final int enterpriseCode;
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
  const ProductsItems({
    super.key,
    required this.enterpriseCode,
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
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItemAsync = ref.watch(selectedItemUIControllerProvider);

    return PopScope(
      onPopInvokedWithResult: (_, _) {
        ref.invalidate(
          searchProductsStateControllerProvider(
            enterpriseCode,
            BsRoutine.researchOfPrice,
            Modules.competingPrices,
          ),
        );
      },
      child: AsyncValueWidget(
        value: ref.watch(
          searchProductsStateControllerProvider(
            enterpriseCode,
            BsRoutine.researchOfPrice,
            Modules.competingPrices,
          ),
        ),
        tryAgain: null,
        data: (products) {
          return Expanded(
            child: ResponsiveListFlow(
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];

                return ProductItemWidget(
                  product: product,
                  routine: BsRoutine.researchOfPrice,
                  showDropIcon: true,
                  notClickableBottom: selectedItemAsync.selectedIndex == index
                      ? PricesFieldsAndSubmit(widget: this, product: product)
                      : null,
                  onTap: () {
                    ref
                        .read(selectedItemUIControllerProvider.notifier)
                        .update(
                          selectedItemAsync.copyWith(selectedIndex: index),
                        );
                    retailController.text =
                        (product.RetailPracticedPrice?.toStringAsFixed(2) ?? '')
                            .replaceAll(RegExp(r'\.'), ',');
                    retailOfferController.text =
                        (product.RetailOfferPrice?.toStringAsFixed(2) ?? '')
                            .replaceAll(RegExp(r'\.'), ',');
                    wholeController.text =
                        (product.WholePracticedPrice?.toStringAsFixed(2) ?? '')
                            .replaceAll(RegExp(r'\.'), ',');
                    wholeOfferController.text =
                        (product.WholeOfferPrice?.toStringAsFixed(2) ?? '')
                            .replaceAll(RegExp(r'\.'), ',');
                    ecommerceController.text =
                        (product.ECommercePracticedPrice?.toStringAsFixed(2) ??
                                '')
                            .replaceAll(RegExp(r'\.'), ',');
                    ecommerceOfferController.text =
                        (product.ECommerceOfferPrice?.toStringAsFixed(2) ?? '')
                            .replaceAll(RegExp(r'\.'), ',');
                  },
                  clickableBottom: AppliedPrices(product: product),
                  isSelected: ref.watch(
                    selectedItemUIControllerProvider.select(
                      (s) => s.selectedIndex == index,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
