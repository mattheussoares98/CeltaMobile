import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController passwordController;
  final bool isLoading;
  final FocusNode passwordFocusNode;
  final VoidCallback onSubmit;
  const PasswordField({
    super.key,
    required this.passwordController,
    required this.isLoading,
    required this.passwordFocusNode,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      enabled: !isLoading,
      focusNode: passwordFocusNode,
      controller: passwordController,
      validator: FormValidators.compose([NonEmptyValidator()]),
      onFieldSubmitted: (_) => onSubmit(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      labelText: 'Senha'.hardcoded,
      hintText: 'Senha'.hardcoded,
      prefixIcon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.lock_fill,
        materialIcon: Icons.lock_outline,
      ),
      obscureText: true,
    );
  }
}
