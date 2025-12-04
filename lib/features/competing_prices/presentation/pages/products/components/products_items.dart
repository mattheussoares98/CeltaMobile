import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../controllers/controllers.dart';
import '../products.dart';
import 'components.dart';

class ProductsItems extends ConsumerWidget {
  final ProductsPage widget;
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
    required this.widget,
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
    final searchProductKey = SearchProductKey(
      widget.enterpriseCode,
      BsRoutine.researchOfPrice,
      Modules.competingPrices,
    );

    return PopScope(
      onPopInvokedWithResult: (_, _) {
        ref.invalidate(searchProductsStateControllerProvider(searchProductKey));
      },
      child: AsyncValueWidget(
        value: ref.watch(
          searchProductsStateControllerProvider(searchProductKey),
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
                    String getNewValue(double? price) {
                      return price == null || price == 0
                          ? ''
                          : price
                                .toStringAsFixed(2)
                                .replaceAll(RegExp(r'\.'), ',');
                    }

                    retailController.text = getNewValue(
                      product.RetailPracticedPrice,
                    );
                    retailOfferController.text = getNewValue(
                      product.RetailOfferPrice,
                    );
                    wholeController.text = getNewValue(
                      product.WholePracticedPrice,
                    );
                    wholeOfferController.text = getNewValue(
                      product.WholeOfferPrice,
                    );
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
