import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/personal_data/components/components.dart';
import 'package:flutter/cupertino.dart';

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
    return BaseTextFormField(
      controller: passwordConfirmationController,
      maxLength: 20,
      hintText: context.l10n.confirmPassword,
      labelText: context.l10n.confirmPassword,
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

        return context.l10n.passwordsDoNotMatch;
      },
      suffixIcon: DefaultDeleteIcon(controller: passwordConfirmationController),
    );
  }
}
