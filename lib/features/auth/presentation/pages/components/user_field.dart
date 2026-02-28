import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/validators/validators.dart';
import '../../controllers/controllers.dart';

class UserField extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(
      loginControllerProvider.select((s) => s.isLoading),
    );

    return DefaultTextFormField(
      enabled: !isLoading,
      focusNode: userFocusNode,
      controller: userController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        passwordFocusNode.requestFocus();
      },
      validator: FormValidators.compose([NonEmptyValidator()]),
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
