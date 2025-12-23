import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';

class QuantityField extends StatelessWidget {
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final FocusNode quantityFocusNode;
  final FocusNode priceFocusNode;
  final bool requestTypeAllowChangePrice;
  final VoidCallback update;
  const QuantityField({
    super.key,
    required this.quantityController,
    required this.priceController,
    required this.quantityFocusNode,
    required this.priceFocusNode,
    required this.requestTypeAllowChangePrice,
    required this.update,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      labelText: 'Quantidade'.hardcoded,
      hintText: 'Quantidade'.hardcoded,
      controller: quantityController,
      focusNode: quantityFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 13,
      onTap: () {
        if (quantityFocusNode.hasFocus) return;
        quantityController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: quantityController.text.length,
        );
      },
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onFieldSubmitted: (_) {
        if (requestTypeAllowChangePrice) {
          priceFocusNode.requestFocus();
          priceController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: priceController.text.length,
          );
        } else {
          update();
        }
      },
      validator: FormValidators.compose([
        NonEmptyValidator(),
        NumberValidator(allowDecimal: true, maxDecimalHouses: 3),
      ]),
    );
  }
}
