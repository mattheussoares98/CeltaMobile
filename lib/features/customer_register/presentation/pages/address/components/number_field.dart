import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';
import '../address.dart';

class NumberField extends StatelessWidget {
  const NumberField({super.key, required this.isLoading, required this.page});

  final bool isLoading;
  final AddressPage page;

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      enabled: !isLoading,
      controller: page.numberController,
      focusNode: page.numberFocusNode,
      labelText: 'Número'.hardcoded,
      hintText: 'Número'.hardcoded,
      validator: FormValidators.compose([
        NonEmptyValidator(),
        MinLengthValidator(1),
        NumberValidator(allowDecimal: false),
      ]),
      onFieldSubmitted: (_) {
        page.complementFocusNode.requestFocus();
      },
      keyboardType: TextInputType.numberWithOptions(
        decimal: false,
      ), //TODO test in iOS
    );
  }
}
