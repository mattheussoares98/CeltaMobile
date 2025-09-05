import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/presentation/theme/theme.dart';

class EmailField extends StatelessWidget {
  final TextEditingController emailController;
  final bool isLoading;
  const EmailField({
    super.key,
    required this.emailController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      enabled: !isLoading,
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
