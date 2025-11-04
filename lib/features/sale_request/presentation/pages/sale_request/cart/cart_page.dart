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
  int? selectedIndex;
  PercentageOrValue? discountType;
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
    if (selectedIndex == index) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });

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
      }
      if (product.DiscountPercentageOrValue != null) {
        setState(() {
          discountType = product.DiscountPercentageOrValue;
        });
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        quantityFocusNode.requestFocus();
        quantityController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: quantityController.text.length,
        );
      });
    }
  }

  void updateProduct(
    CartProductEntity cartProduct,
    PercentageOrValue? discountType,
  ) {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    double quantity = quantityController.text.toDouble()!;
    double? discount = discountController.text.toDouble();
    double value = priceController.text.toDouble()!;

    ref
        .read(pendingSaleRequestStateControllerProvider.notifier)
        .addProduct(
          CartProductEntity.create(
            discountByItem: discount,
            discountType: discountType,
            productPackingCode: cartProduct.ProductPackingCode,
            quantity: quantity,
            price: value,
            name: cartProduct.Name,
            plu: cartProduct.Plu,
            packingQuantity: cartProduct.PackingQuantity,
          ),
        );

    quantityController.clear();
    discountController.clear();
    setState(() {
      selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AsyncValueWidget(
      value: ref.watch(pendingSaleRequestStateControllerProvider),
      tryAgain: null,
      data: (data) {
        final products = ref.watch(
          pendingSaleRequestStateControllerProvider.select(
            (state) => state.value?.cart.values.toList() ?? [],
          ),
        );

        if (products.isEmpty) {
          return Center(child: Text('Nenhum item no carrinho'.hardcoded));
        }

        return ResponsiveListFlow(
          itemCount: products.length,
          itemBuilder: (_, index) {
            final product = products[index];

            return ProductItem(
              product: product,
              onTap: () => changeSelectedIndex(index, product),
              isSelected: selectedIndex == index,
              updateProduct: updateProduct,
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
      },
    );
  }
}
