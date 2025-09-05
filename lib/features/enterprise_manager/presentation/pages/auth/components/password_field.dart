import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/presentation/theme/theme.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController passwordController;
  final bool isLoading;
  const PasswordField({
    super.key,
    required this.passwordController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      enabled: !isLoading,
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
