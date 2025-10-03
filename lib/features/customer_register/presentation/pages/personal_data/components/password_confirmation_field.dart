import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../personal_data.dart';
import 'components.dart';

class PasswordConfirmationField extends StatelessWidget {
  final PersonalDataPage personalDataPage;
  const PasswordConfirmationField({super.key, required this.personalDataPage});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: personalDataPage.passwordConfirmationController,
      maxLength: 20,
      hintText: 'Confirmar senha'.hardcoded,
      labelText: 'Confirmar senha'.hardcoded,
      obscureText: true,
      focusNode: personalDataPage.passwordConfirmationFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (personalDataPage.passwordController.text.isEmpty &&
            personalDataPage.passwordConfirmationController.text.isEmpty) {
          return null;
        } else if (personalDataPage.passwordController.text == value) {
          return null;
        }

        return 'As senhas não conferem'.hardcoded;
      },
      suffixIcon: DefaultDeleteIcon(
        controller: personalDataPage.passwordConfirmationController,
      ),
    );
  }
}
