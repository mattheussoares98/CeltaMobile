import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/validators/validators.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';

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
      controller: widget.passwordController,
      focusNode: widget.passwordFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: isLoading ? null : (_) => widget.onSubmit.call(),
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
        onPressed: isLoading ? null : toggleShowPassword,
        icon: _PasswordIcon(showPassword: showPassword),
        color: isLoading ? theme.disabledColor : null,
      ),
      obscureText: !showPassword,
    );
  }
}

class _PasswordIcon extends StatelessWidget {
  final bool showPassword;
  const _PasswordIcon({required this.showPassword});

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
