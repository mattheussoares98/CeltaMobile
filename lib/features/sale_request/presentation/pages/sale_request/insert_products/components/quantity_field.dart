import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';

class QuantityField extends StatelessWidget {
  final bool requestTypeAllowChangePrice;
  final FocusNode quantityFocusNode;
  final TextEditingController quantityController;
  final FocusNode priceFocusNode;
  final VoidCallback insertProduct;
  const QuantityField({
    super.key,
    required this.requestTypeAllowChangePrice,
    required this.quantityFocusNode,
    required this.quantityController,
    required this.priceFocusNode,
    required this.insertProduct,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      labelText: 'Quantidade'.hardcoded,
      hintText: 'Quantidade'.hardcoded,
      maxLength: 13,
      controller: quantityController,
      focusNode: quantityFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        if (requestTypeAllowChangePrice) {
          priceFocusNode.requestFocus();
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
