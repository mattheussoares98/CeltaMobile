import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/presentation/theme/app_decorations.dart';
import '../../../../../localization/string_hardcoded.dart';

class EmailField extends StatelessWidget {
  final TextEditingController emailController;
  const EmailField({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: emailController,
      decoration: AppDecorations.input(
        context: context,
        labelText: 'Email'.hardcoded,
        prefixIcon: Icon(
          theme.platform == TargetPlatform.iOS
              ? CupertinoIcons.mail_solid
              : Icons.email_outlined,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
