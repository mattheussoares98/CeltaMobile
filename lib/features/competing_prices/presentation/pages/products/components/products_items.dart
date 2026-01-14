import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../controllers/controllers.dart';
import '../products.dart';
import 'components.dart';

class ProductsItems extends ConsumerStatefulWidget {
  final ProductsPage widget;
  const ProductsItems({super.key, required this.widget});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends ConsumerState<ProductsItems> {
  final retailController = TextEditingController();
  final retailOfferController = TextEditingController();
  final wholeController = TextEditingController();
  final wholeOfferController = TextEditingController();
  final ecommerceController = TextEditingController();
  final ecommerceOfferController = TextEditingController();
  final retailFocusNode = FocusNode();
  final retailOfferFocusNode = FocusNode();
  final wholeFocusNode = FocusNode();
  final wholeOfferFocusNode = FocusNode();
  final ecommerceFocusNode = FocusNode();
  final ecommerceOfferFocusNode = FocusNode();

  @override
  dispose() {
    super.dispose();
    retailController.dispose();
    retailOfferController.dispose();
    wholeController.dispose();
    wholeOfferController.dispose();
    ecommerceController.dispose();
    ecommerceOfferController.dispose();
    retailFocusNode.dispose();
    retailOfferFocusNode.dispose();
    wholeFocusNode.dispose();
    wholeOfferFocusNode.dispose();
    ecommerceFocusNode.dispose();
    ecommerceOfferFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItemAsync = ref.watch(selectedItemUIControllerProvider);
    final searchProductKey = SearchProductKey(
      widget.widget.enterpriseCode,
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
