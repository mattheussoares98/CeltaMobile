import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/quantity_price_discount/quantity_price_discount.dart';

class QuantityField extends StatelessWidget {
  final VoidCallback insertProduct;
  final QuantityPriceDiscountFieldsAndInsertButton widget;
  const QuantityField({
    super.key,
    required this.insertProduct,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      labelText: 'Quantidade'.hardcoded,
      hintText: 'Quantidade'.hardcoded,
      maxLength: 13,
      controller: widget.quantityController,
      focusNode: widget.quantityFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onFieldSubmitted: (_) {
        if (widget.selectedRequest.allowAlterCostOrSalePrice == true &&
            widget.discountController.text.isEmpty) {
          widget.priceFocusNode.requestFocus();
        } else {
          insertProduct();
        }
      },
      validator: FormValidators.compose([
        NonEmptyValidator(),
        NumberValidator(allowDecimal: true, maxDecimalHouses: 3),
      ]),
    );
  }
}
