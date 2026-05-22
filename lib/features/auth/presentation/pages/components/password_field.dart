import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/auth/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';

class PasswordField extends ConsumerStatefulWidget {
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final VoidCallback onSubmit;
  const PasswordField({
    super.key,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.onSubmit,
  });

  @override
  ConsumerState<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends ConsumerState<PasswordField> {
  bool showPassword = false;

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(
      loginControllerProvider.select((s) => s.isLoading),
    );

    return DefaultTextFormField(
      enabled: !isLoading,
      focusNode: widget.passwordFocusNode,
      controller: widget.passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: isLoading ? null : (_) => widget.onSubmit.call(),
      textInputAction: TextInputAction.done,
      validator: FormValidators.compose([NonEmptyValidator()]),
      maxLength: 30,
      labelText: 'Senha'.hardcoded,
      prefixIcon: Icon(
        PlatformUtil.isCupertino
            ? CupertinoIcons.lock_fill
            : Icons.lock_outline,
        color: isLoading ? theme.disabledColor : null,
      ),
      suffixIcon: IconButton(
        onPressed: isLoading ? null : toggleShowPassword,
        icon: PlatformIcon(
          cupertinoIcon: showPassword
              ? CupertinoIcons.eye
              : CupertinoIcons.eye_slash,
          materialIcon: showPassword ? Icons.visibility : Icons.visibility_off,
        ),
        color: isLoading ? theme.disabledColor : null,
      ),
      obscureText: !showPassword,
    );
  }
}
