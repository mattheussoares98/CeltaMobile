import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';
import '../personal_data.dart';
import 'components.dart';

class PasswordField extends StatelessWidget {
  final PersonalDataPage personalDataPage;
  const PasswordField({super.key, required this.personalDataPage});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: personalDataPage.passwordController,
      maxLength: 20,
      hintText: 'Senha'.hardcoded,
      labelText: 'Senha'.hardcoded,
      obscureText: true,
      focusNode: personalDataPage.passwordFocusNode,
      onFieldSubmitted: (_) {
        personalDataPage.passwordConfirmationFocusNode.requestFocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return null;
        } else if (MinLengthValidator(3).isValid(value)) {
          return null;
        }

        return MinLengthValidator(3).errorMessage;
      },
      suffixIcon: DefaultDeleteIcon(
        controller: personalDataPage.passwordController,
      ),
    );
  }
}
