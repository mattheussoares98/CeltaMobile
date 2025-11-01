import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';

class QuantityFormField extends StatelessWidget {
  final GlobalKey<FormState>? quantityFormKey;
  final FocusNode quantityFocusNode;
  final TextEditingController quantityController;
  final TextEditingController costController;
  final FocusNode costFocusNode;
  const QuantityFormField({
    super.key,
    required this.quantityFormKey,
    required this.quantityFocusNode,
    required this.quantityController,
    required this.costController,
    required this.costFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: quantityFormKey,
      child: DefaultTextFormField(
        focusNode: quantityFocusNode,
        controller: quantityController,
        labelText: 'Quantidade'.hardcoded,
        hintText: 'Quantidade'.hardcoded,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          //TODO test in iOS
        ),
        validator: FormValidators.compose([
          NonEmptyValidator(),
          NumberValidator(allowDecimal: true, maxDecimalHouses: 3),
        ]),
        maxLength: 13,
        onFieldSubmitted: (_) {
          if (quantityFormKey?.currentState?.validate() != true) {
            quantityFocusNode.requestFocus();
          } else {
            costController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: costController.text.length,
            );
            costFocusNode.requestFocus();
          }
        },
      ),
    );
  }
}
