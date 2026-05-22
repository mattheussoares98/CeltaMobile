import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/create_enterprise/components/components.dart';

class PasswordField extends StatelessWidget {
  final bool isLoading;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final VoidCallback onSubmit;
  const PasswordField({
    super.key,
    required this.isLoading,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      enabled: !isLoading,
      controller: passwordController,
      focusNode: passwordFocusNode,
      onFieldSubmitted: (_) {
        onSubmit();
      },
      labelText: "Senha".hardcoded,
      hintText: "Senha".hardcoded,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      suffixIcon: DeleteIcon(
        onPress: isLoading ? null : passwordController.clear,
      ),
      obscureText: true,
      validator: FormValidators.compose([NonEmptyValidator()]),
    );
  }
}
