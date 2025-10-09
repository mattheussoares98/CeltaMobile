import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';

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
    final theme = Theme.of(context);

    return DefaultTextFormField(
      enabled: !isLoading,
      focusNode: passwordFocusNode,
      controller: passwordController,
      validator: FormValidators.compose([NonEmptyValidator()]),
      onFieldSubmitted: (_) => onSubmit(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      labelText: 'Senha'.hardcoded,
      hintText: 'Senha'.hardcoded,
      prefixIcon: Icon(
        theme.platform == TargetPlatform.iOS
            ? CupertinoIcons.lock_fill
            : Icons.lock_outline,
      ),
      obscureText: true,
    );
  }
}
