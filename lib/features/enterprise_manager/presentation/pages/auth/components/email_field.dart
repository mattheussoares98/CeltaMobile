import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';

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
    final theme = Theme.of(context);

    return DefaultTextFormField(
      enabled: !isLoading,
      controller: emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      labelText: 'Email'.hardcoded,
      hintText: 'Email'.hardcoded,
      onFieldSubmitted: (_) {
        passwordFocusNode.requestFocus();
      },
      validator: FormValidators.compose([EmailValidator()]),
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icon(
        theme.platform == TargetPlatform.iOS
            ? CupertinoIcons.mail_solid
            : Icons.email_outlined,
      ),
    );
  }
}
