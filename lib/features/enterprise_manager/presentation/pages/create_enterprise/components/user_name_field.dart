import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/presentation/theme/theme.dart';
import 'components.dart';

class UserNameField extends StatelessWidget {
  final TextEditingController userNameController;
  final FocusNode userNameFocusNode;
  final bool isLoading;
  final FocusNode passwordFocusNode;
  const UserNameField({
    super.key,
    required this.userNameController,
    required this.userNameFocusNode,
    required this.isLoading,
    required this.passwordFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: !isLoading,
      controller: userNameController,
      focusNode: userNameFocusNode,
      onFieldSubmitted: (_) {
        passwordFocusNode.requestFocus();
      },
      decoration: AppDecorations.input(
        context: context,
        hintText: "Nome do usuário no BS".hardcoded,
        suffixIcon: DeleteIcon(
          onPress: isLoading ? null : userNameController.clear,
        ),
      ),
    );
  }
}
