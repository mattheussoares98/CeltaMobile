import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/presentation/theme/app_decorations.dart';
import '../../../../../core/validators/validators.dart';
import '../../../../../localization/string_hardcoded.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final VoidCallback? onSubmit;
  final bool isLoading;
  const PasswordField({
    super.key,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      enabled: !isLoading,
      controller: passwordController,
      focusNode: passwordFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        onSubmit?.call();
      },
      validator: FormValidators.compose([NonEmptyValidator()]),
      decoration: AppDecorations.input(
        context: context,
        labelText: 'Senha'.hardcoded,
        prefixIcon: Icon(
          theme.platform == TargetPlatform.iOS
              ? CupertinoIcons.lock_fill
              : Icons.lock_outline,
        ),
      ),
      obscureText: true,
    );
  }
}
