import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/string_modifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../domain/entities/entities.dart';

class PriceField extends StatelessWidget {
  final VoidCallback insertProduct;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final FocusNode priceFocusNode;
  final FocusNode discountFocusNode;
  final RequestTypeEntity selectedRequest;
  final ProductEntity product;
  final CartProductEntity? cartProduct;
  final bool isCartPage;
  const PriceField({
    super.key,
    required this.insertProduct,
    required this.priceController,
    required this.quantityController,
    required this.priceFocusNode,
    required this.discountFocusNode,
    required this.selectedRequest,
    required this.product,
    required this.cartProduct,
    required this.isCartPage,
  });

  double get totalQuantity {
    final writtenQuantity = quantityController.text.toDouble() ?? 0;
    final cartQuantity = cartProduct?.Quantity ?? 0;

    return isCartPage ? writtenQuantity : cartQuantity + writtenQuantity;
  }

  double get practicedPrice {
    if (totalQuantity >= product.MinimumWholeQuantity &&
        product.WholePracticedPrice > 0) {
      return product.WholePracticedPrice;
    } else if (product.getPrice == 0 && (cartProduct?.Value ?? 0) > 0) {
      return cartProduct!.Value;
    }
    return product.getPrice;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return AnimatedBuilder(
      animation: Listenable.merge([quantityController]),
      builder: (_, _) {
        Future.delayed(Duration.zero, () {
          priceController.text = practicedPrice
              .toString()
              .toBrazilianNumber()
              .replaceAll(RegExp(r'\.'), '');
        });
        return DefaultTextFormField(
          labelText: 'Preço unitário'.hardcoded,
          hintText: 'Preço unitário'.hardcoded,
          maxLength: 13,
          controller: priceController,
          focusNode: priceFocusNode,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          suffixIcon: IconButton(
            onPressed: () {
              showAlertDialog(
                context: context,
                title: 'Atenção!'.hardcoded,
                content:
                    'Esse campo está habilitado porque o modelo de pedido permite alterar o preço'
                        .hardcoded,
              );
            },
            icon: Icon(isIOS ? CupertinoIcons.info : Icons.info),
          ),
          onFieldSubmitted: (_) {
            if (selectedRequest.AllowDiscount == true) {
              discountFocusNode.requestFocus();
            } else {
              insertProduct();
            }
          },
          validator: FormValidators.compose([
            NonEmptyValidator(),
            NumberValidator(allowDecimal: true),
          ]),
        );
      },
    );
  }
}
