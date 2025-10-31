import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../domain/entities/entities.dart';
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
  int? selectedIndex;

  @override
  void dispose() {
    super.dispose();
    searchProductsController.dispose();
    quantityController.dispose();
    quantityFocusNode.dispose();
    priceController.dispose();
    priceFocusNode.dispose();
  }

  void onTapProduct(
    int? index,
    ProductEntity product,
    CartProductEntity? cartProduct,
  ) {
    if (product.Value == 0 &&
        product.RetailPracticedPrice == 0 &&
        widget.selectedRequest.AllowAlterCostOrSalePrice != true) {
      showSnackBarMessage(
        context,
        'Esse produto está com o preço zerado e o modelo não permite alterar o preço'
            .hardcoded,
        backgroundColor: Colors.red,
      );
    } else if (index == selectedIndex || index == null) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });

      final cartProductPrice = (cartProduct?.getValueLiquid ?? 0);
      final productPrice = product.getPrice;
      double? price = cartProductPrice == 0 ? productPrice : cartProductPrice;

      if (price > 0) {
        priceController.text = price.toString().replaceAll(RegExp(r'\.'), ',');
      } else {
        priceController.clear();
      }
      quantityController.text = '1';

      Future.delayed(Duration(milliseconds: 100), () {
        quantityFocusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Sizes.p8, 0, Sizes.p8, Sizes.p8),
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
              selectedIndex: selectedIndex,
              onTapProduct: onTapProduct,
              quantityController: quantityController,
              quantityFocusNode: quantityFocusNode,
              priceController: priceController,
              priceFocusNode: priceFocusNode,
              removeSelectedIndex: () {
                setState(() {
                  selectedIndex = null;
                });
              },
              selectedRequest: widget.selectedRequest,
            ),
          ),
        ],
      ),
    );
  }
}
