import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';

class NumberField extends StatelessWidget {
  final bool isLoading;
  final TextEditingController numberController;
  final FocusNode numberFocusNode;
  final FocusNode complementFocusNode;
  const NumberField({
    super.key,
    required this.isLoading,
    required this.numberController,
    required this.numberFocusNode,
    required this.complementFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      enabled: !isLoading,
      controller: numberController,
      focusNode: numberFocusNode,
      labelText: 'Número'.hardcoded,
      hintText: 'Número'.hardcoded,
      maxLength: 5,
      validator: FormValidators.compose([
        NonEmptyValidator(),
        MinLengthValidator(1),
        NumberValidator(allowDecimal: false),
      ]),
      onFieldSubmitted: (_) {
        complementFocusNode.requestFocus();
      },
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
    );
  }
}
