import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/presentation/theme/app_decorations.dart';
import '../../../../../core/validators/validators.dart';
import '../../../../../localization/string_hardcoded.dart';

class UserField extends StatelessWidget {
  final TextEditingController userController;
  final FocusNode userFocusNode;
  final FocusNode passwordFocusNode;
  const UserField({
    super.key,
    required this.userController,
    required this.userFocusNode,
    required this.passwordFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      focusNode: userFocusNode,
      controller: userController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        passwordFocusNode.requestFocus();
      },
      validator: FormValidators.compose([NonEmptyValidator()]),
      decoration: AppDecorations.input(
        context: context,
        labelText: 'Usuário'.hardcoded,
        prefixIcon: Icon(
          theme.platform == TargetPlatform.iOS
              ? CupertinoIcons.person
              : Icons.person,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
