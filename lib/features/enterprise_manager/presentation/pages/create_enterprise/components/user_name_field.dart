import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/create_enterprise/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

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
    return BaseTextFormField(
      enabled: !isLoading,
      controller: userNameController,
      focusNode: userNameFocusNode,
      onFieldSubmitted: (_) {
        passwordFocusNode.requestFocus();
      },
      labelText: "Nome do usuário no BS".hardcoded,
      hintText: "Nome do usuário no BS".hardcoded,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      suffixIcon: DeleteIcon(
        onPress: isLoading ? null : userNameController.clear,
      ),
      validator: FormValidators.compose([const NonEmptyValidator()]),
    );
  }
}
