import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/presentation/theme/app_decorations.dart';
import '../../../../../localization/string_hardcoded.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController passwordController;
  const PasswordField({super.key, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: passwordController,
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
