import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import 'components.dart';

class QuantityField extends StatelessWidget {
  final VoidCallback insertProduct;
  final ProductsItems productsItems;
  const QuantityField({
    super.key,
    required this.insertProduct,
    required this.productsItems,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      labelText: 'Quantidade'.hardcoded,
      hintText: 'Quantidade'.hardcoded,
      maxLength: 13,
      controller: productsItems.quantityController,
      focusNode: productsItems.quantityFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        if (productsItems.selectedRequest.AllowAlterCostOrSalePrice == true) {
          productsItems.priceFocusNode.requestFocus();
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
