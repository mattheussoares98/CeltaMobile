import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/personal_data/components/components.dart';

class PasswordConfirmationField extends StatelessWidget {
  final TextEditingController passwordConfirmationController;
  final FocusNode passwordConfirmationFocusNode;
  final TextEditingController passwordController;

  const PasswordConfirmationField({
    super.key,
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.passwordConfirmationFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: passwordConfirmationController,
      maxLength: 20,
      hintText: 'Confirmar senha'.hardcoded,
      labelText: 'Confirmar senha'.hardcoded,
      obscureText: true,
      focusNode: passwordConfirmationFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (passwordController.text.isEmpty &&
            passwordConfirmationController.text.isEmpty) {
          return null;
        } else if (passwordController.text == value) {
          return null;
        }

        return 'As senhas não conferem'.hardcoded;
      },
      suffixIcon: DefaultDeleteIcon(controller: passwordConfirmationController),
    );
  }
}
