import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/competing_prices/presentation/pages/products/components/components.dart';

class ProductsItems extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int researchCode;
  final int concurrentCode;
  const ProductsItems({
    super.key,
    required this.enterpriseCode,
    required this.researchCode,
    required this.concurrentCode,
  });

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
        isSliver: true,
        value: ref.watch(
          searchProductsStateControllerProvider(searchProductKey),
        ),
        tryAgain: null,
        data: (products) {
          return ResponsiveListFlow(
            isSliver: true,
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];

              return ProductItem(
                key: ValueKey(product.ProductPackingCode),
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
                index: index,
                enterpriseCode: widget.enterpriseCode,
                researchCode: widget.researchCode,
                concurrentCode: widget.concurrentCode,
              );
            },
          );
        },
      ),
    );
  }
}
