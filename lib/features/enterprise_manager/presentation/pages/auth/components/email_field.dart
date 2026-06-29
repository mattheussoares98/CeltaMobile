import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController emailController;
  final bool isLoading;
  final FocusNode passwordFocusNode;
  const EmailField({
    super.key,
    required this.emailController,
    required this.isLoading,
    required this.passwordFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      enabled: !isLoading,
      controller: emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      labelText: 'E-mail'.hardcoded,
      hintText: 'E-mail'.hardcoded,
      onFieldSubmitted: (_) {
        passwordFocusNode.requestFocus();
      },
      validator: FormValidators.compose([EmailValidator()]),
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const PlatformIcon(
        cupertinoIcon: CupertinoIcons.mail_solid,
        materialIcon: Icons.email_outlined,
      ),
    );
  }
}
