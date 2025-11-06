import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class CartPage extends ConsumerStatefulWidget {
  final RequestTypeEntity selectedRequest;
  const CartPage({super.key, required this.selectedRequest});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  final quantityController = TextEditingController();
  final discountController = TextEditingController();
  final priceController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final discountFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    quantityController.dispose();
    discountController.dispose();
    priceController.dispose();
    quantityFocusNode.dispose();
    discountFocusNode.dispose();
    priceFocusNode.dispose();
  }

  void changeSelectedIndex(int? index, CartProductEntity product) {
    ref
        .read(selectedItemUIControllerProvider(isCartPage: true).notifier)
        .selectProduct(product.ProductPackingCode, product);

    final selectedPackingCode = ref
        .read(selectedItemUIControllerProvider(isCartPage: true))
        .productPackingCode;

    if (selectedPackingCode == null) {
      return;
    }

    quantityController.text = product.Quantity.toString()
        .toBrazilianNumber(3, true)
        .replaceAll(RegExp(r'\.'), '');
    priceController.text = product.Value.toString()
        .toBrazilianNumber(2, true)
        .replaceAll(RegExp(r'\.'), '');
    if ((product.DiscountValue ?? 0) > 0) {
      discountController.text = product.getValueOrPercentageDiscount
          .toString()
          .toBrazilianNumber()
          .replaceAll(RegExp(r'\.'), '');
    } else {
      discountController.clear();
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      quantityFocusNode.requestFocus();
      quantityController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: quantityController.text.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProducts = ref.watch(
      pendingSaleRequestStateControllerProvider.select(
        (state) => state.value?.cart.values.toList() ?? [],
      ),
    );

    return ResponsiveListFlow(
      itemCount: cartProducts.length,
      itemBuilder: (_, index) {
        final cartProduct = cartProducts[index];

        if (cartProducts.isEmpty) {
          return Center(child: Text('Nenhum item no carrinho'.hardcoded));
        }

        return ProductItem(
          cartProduct: cartProduct,
          formKey: formKey,
          onTap: () => changeSelectedIndex(index, cartProduct),
          quantityController: quantityController,
          priceController: priceController,
          discountController: discountController,
          quantityFocusNode: quantityFocusNode,
          discountFocusNode: discountFocusNode,
          priceFocusNode: priceFocusNode,
          selectedRequest: widget.selectedRequest,
        );
      },
    );
  }
}
