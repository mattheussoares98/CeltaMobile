import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/validators/validators.dart';

class UserField extends StatelessWidget {
  final TextEditingController userController;
  final FocusNode userFocusNode;
  final FocusNode passwordFocusNode;
  final bool isLoading;
  const UserField({
    super.key,
    required this.userController,
    required this.userFocusNode,
    required this.passwordFocusNode,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTextFormField(
      enabled: !isLoading,
      focusNode: userFocusNode,
      controller: userController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        passwordFocusNode.requestFocus();
      },
      validator: FormValidators.compose([NonEmptyValidator()]),
      keyboardType: TextInputType.emailAddress,
      maxLength: 40,
      labelText: 'Usuário'.hardcoded,
      prefixIcon: Icon(
        theme.platform == TargetPlatform.iOS
            ? CupertinoIcons.person
            : Icons.person,
        color: isLoading ? theme.disabledColor : null,
      ),
    );
  }
}
