import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/validators/validators.dart';
import '../../../../../localization/string_hardcoded.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final VoidCallback? onSubmit;
  final VoidCallback changeShowPassword;
  final bool isLoading;
  final bool showPassword;
  const PasswordField({
    super.key,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.onSubmit,
    required this.changeShowPassword,
    required this.isLoading,
    required this.showPassword,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTextFormField(
      enabled: !isLoading,
      controller: passwordController,
      focusNode: passwordFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        onSubmit?.call();
      },
      validator: FormValidators.compose([NonEmptyValidator()]),
      maxLength: 30,
      labelText: 'Senha'.hardcoded,
      prefixIcon: Icon(
        theme.platform == TargetPlatform.iOS
            ? CupertinoIcons.lock_fill
            : Icons.lock_outline,
        color: isLoading ? theme.disabledColor : null,
      ),
      suffixIcon: IconButton(
        onPressed: changeShowPassword,
        icon: _PasswordIcon(
          changeShowPassword: changeShowPassword,
          showPassword: showPassword,
        ),
        color: isLoading ? theme.disabledColor : null,
      ),
      obscureText: !showPassword,
    );
  }
}

class _PasswordIcon extends StatelessWidget {
  final VoidCallback? changeShowPassword;
  final bool showPassword;
  const _PasswordIcon({
    required this.changeShowPassword,
    required this.showPassword,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (theme.platform == TargetPlatform.iOS) {
      return Icon(showPassword ? CupertinoIcons.eye : CupertinoIcons.eye_slash);
    } else {
      return Icon(showPassword ? Icons.visibility : Icons.visibility_off);
    }
  }
}
