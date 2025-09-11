import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/presentation/theme/theme.dart';
import 'components.dart';

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
    return TextFormField(
      enabled: !isLoading,
      controller: passwordController,
      focusNode: passwordFocusNode,
      onFieldSubmitted: (_) {
        onSubmit();
      },
      decoration: AppDecorations.input(
        context: context,
        hintText: "Senha".hardcoded,
        suffixIcon: DeleteIcon(
          onPress: isLoading ? null : passwordController.clear,
        ),
      ),
      obscureText: true,
    );
  }
}
