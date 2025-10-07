import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';
import '../phone.dart';

class PhoneField extends StatelessWidget {
  const PhoneField(this.page, {super.key});

  final PhonePage page;

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: page.phoneController,
      focusNode: page.phoneFocusNode,
      inputFormatters: [PhoneInputFormatter()],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      labelText: 'Telefone'.hardcoded,
      hintText: 'Telefone'.hardcoded,
      onFieldSubmitted: (_) {
        page.addPhone();
      },
      validator: FormValidators.compose([
        NonEmptyValidator(),
        MinLengthValidator(8),
        NumberValidator(allowDecimal: false),
      ]),
    );
  }
}
