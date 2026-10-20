import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/personal_data/components/components.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:flutter/cupertino.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final FocusNode passwordConfirmationFocusNode;
  const PasswordField({
    super.key,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.passwordConfirmationFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      controller: passwordController,
      maxLength: 20,
      hintText: 'Senha'.hardcoded,
      labelText: 'Senha'.hardcoded,
      obscureText: true,
      focusNode: passwordFocusNode,
      onFieldSubmitted: (_) {
        passwordConfirmationFocusNode.requestFocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return null;
        } else if (MinLengthValidator(
          3,
          translations: context.l10n,
        ).isValid(value)) {
          return null;
        }

        return MinLengthValidator(3, translations: context.l10n).errorMessage;
      },
      suffixIcon: DefaultDeleteIcon(controller: passwordController),
    );
  }
}
