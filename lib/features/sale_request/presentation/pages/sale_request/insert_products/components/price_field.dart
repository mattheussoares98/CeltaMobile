import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import 'components.dart';

class PriceField extends StatelessWidget {
  final VoidCallback insertProduct;
  final ProductsItems productsItems;

  const PriceField({
    super.key,
    required this.productsItems,
    required this.insertProduct,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      labelText: 'Preço'.hardcoded,
      hintText: 'Preço'.hardcoded,
      maxLength: 13,
      controller: productsItems.priceController,
      focusNode: productsItems.priceFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        if (productsItems.selectedRequest.AllowDiscount == true) {
          productsItems.discountFocusNode.requestFocus();
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
