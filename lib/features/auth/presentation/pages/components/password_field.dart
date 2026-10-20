import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/auth/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final isLoading = ref.watch(
      loginControllerProvider.select((s) => s.isLoading),
    );

    return BaseTextFormField(
      enabled: !isLoading,
      focusNode: widget.passwordFocusNode,
      controller: widget.passwordController,
      autofillHints: const [AutofillHints.password],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: isLoading ? null : (_) => widget.onSubmit.call(),
      textInputAction: TextInputAction.done,
      validator: FormValidators.compose([
        NonEmptyValidator(errorMessage: context.l10n.requiredField),
      ]),
      maxLength: 30,
      labelText: context.l10n.password,
      prefixIcon: Icon(
        PlatformUtil.isCupertino
            ? CupertinoIcons.lock_fill
            : Icons.lock_outline,
        color: isLoading ? context.theme.disabledColor : null,
      ),
      suffixIcon: IconButton(
        tooltip: showPassword
            ? context.l10n.hidePassword
            : context.l10n.showPassword,
        onPressed: isLoading ? null : toggleShowPassword,
        icon: PlatformIcon(
          cupertinoIcon: showPassword
              ? CupertinoIcons.eye
              : CupertinoIcons.eye_slash,
          materialIcon: showPassword ? Icons.visibility : Icons.visibility_off,
        ),
        color: isLoading ? context.theme.disabledColor : null,
      ),
      obscureText: !showPassword,
    );
  }
}
