import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/presentation/theme/theme.dart';
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

    return TextFormField(
      enabled: !isLoading,
      controller: emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: AppDecorations.input(
        //TODO use DefaultTextFormField
        context: context,
        labelText: 'Email'.hardcoded,
        prefixIcon: Icon(
          theme.platform == TargetPlatform.iOS
              ? CupertinoIcons.mail_solid
              : Icons.email_outlined,
        ),
      ),
      onFieldSubmitted: (_) {
        passwordFocusNode.requestFocus();
      },
      validator: FormValidators.compose([EmailValidator()]),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
