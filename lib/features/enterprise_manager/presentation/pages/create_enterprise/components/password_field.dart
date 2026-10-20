import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/create_enterprise/components/components.dart';
import 'package:flutter/material.dart';

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
    return BaseTextFormField(
      enabled: !isLoading,
      controller: passwordController,
      focusNode: passwordFocusNode,
      onFieldSubmitted: (_) {
        onSubmit();
      },
      labelText: context.l10n.password,
      hintText: context.l10n.password,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      suffixIcon: DeleteIcon(
        onPress: isLoading ? null : passwordController.clear,
      ),
      obscureText: true,
      validator: FormValidators.compose([
        NonEmptyValidator(translations: context.l10n),
      ]),
    );
  }
}
