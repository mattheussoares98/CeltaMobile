import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class InsertProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final RequestTypeEntity selectedRequest;
  const InsertProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.selectedRequest,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InsertProductsPageState();
}

class _InsertProductsPageState extends ConsumerState<InsertProductsPage> {
  final searchProductsController = TextEditingController();
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final priceController = TextEditingController();
  final priceFocusNode = FocusNode();
  final discountController = TextEditingController();
  final discountFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    searchProductsController.dispose();
    quantityController.dispose();
    quantityFocusNode.dispose();
    priceController.dispose();
    priceFocusNode.dispose();
    discountController.dispose();
    discountFocusNode.dispose();
  }

  void onTapProduct(ProductEntity product, CartProductEntity? cartProduct) {
    if (product.getPrice == 0 &&
        widget.selectedRequest.AllowAlterCostOrSalePrice != true) {
      showSnackBarMessage(
        context,
        'Esse produto está com o preço zerado e o modelo não permite alterar o preço'
            .hardcoded,
        backgroundColor: Colors.red,
      );
      return;
    }
    ref
        .read(selectedItemUIControllerProvider(isCartPage: false).notifier)
        .selectProduct(product.ProductPackingCode, cartProduct);

    if (ref
            .read(selectedItemUIControllerProvider(isCartPage: false))
            .productPackingCode ==
        null) {
      //selected item is null
      return;
    }

    priceController.clear();
    discountController.clear();

    if ((cartProduct?.Quantity ?? 0) > 0) {
      quantityController.text = cartProduct!.Quantity.toString().replaceAll(
        RegExp(r'\.'),
        ',',
      );
    } else {
      quantityController.text = '1';
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      quantityFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
      child: Column(
        children: [
          SearchProducts(
            enterpriseCode: widget.enterpriseCode,
            searchProductsController: searchProductsController,
          ),
          gapH8,
          Expanded(
            child: ProductsItems(
              enterpriseCode: widget.enterpriseCode,
              onTapProduct: onTapProduct,
              quantityController: quantityController,
              quantityFocusNode: quantityFocusNode,
              priceController: priceController,
              priceFocusNode: priceFocusNode,
              discountController: discountController,
              discountFocusNode: discountFocusNode,
              selectedRequest: widget.selectedRequest,
            ),
          ),
        ],
      ),
    );
  }
}
