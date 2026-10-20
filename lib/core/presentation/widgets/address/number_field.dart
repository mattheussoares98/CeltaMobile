import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:flutter/material.dart';

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
    return BaseTextFormField(
      enabled: !isLoading,
      controller: numberController,
      focusNode: numberFocusNode,
      labelText: context.l10n.number,
      hintText: context.l10n.number,
      maxLength: 5,
      validator: FormValidators.compose([
        NonEmptyValidator(translations: context.l10n),
        MinLengthValidator(1, translations: context.l10n),
        NumberValidator(translations: context.l10n, allowDecimal: false),
      ]),
      onFieldSubmitted: (_) {
        complementFocusNode.requestFocus();
      },
      keyboardType: const TextInputType.numberWithOptions(),
    );
  }
}
