import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import 'components.dart';

class QuantityField extends StatelessWidget {
  final VoidCallback insertProduct;
  final QuantityPriceDiscountFieldsAndInsertButton widget;
  const QuantityField({
    super.key,
    required this.insertProduct,
    required this.widget,
  });

  double get practicedPrice {
    final totalQuantity = widget.quantityController.text.toDouble() ?? 0;

    if (widget.product.MinimumWholeQuantity > 0 &&
        totalQuantity >= widget.product.MinimumWholeQuantity &&
        widget.product.WholePracticedPrice > 0) {
      return widget.product.WholePracticedPrice;
    } else if (widget.product.getPrice == 0 &&
        (widget.cartProduct?.Value ?? 0) > 0) {
      return widget.cartProduct!.Value;
    }
    return widget.product.getPrice;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      labelText: 'Quantidade'.hardcoded,
      hintText: 'Quantidade'.hardcoded,
      maxLength: 13,
      controller: widget.quantityController,
      focusNode: widget.quantityFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          widget.priceController.text = practicedPrice
              .toString()
              .toBrazilianNumber()
              .replaceAll(RegExp(r'\.'), '');
        });
      },
      onFieldSubmitted: (_) {
        if (widget.selectedRequest.AllowAlterCostOrSalePrice == true) {
          widget.priceFocusNode.requestFocus();
        } else {
          insertProduct();
        }
      },
      validator: FormValidators.compose([
        NonEmptyValidator(),
        NumberValidator(allowDecimal: true),
      ]),
    );
  }
}
