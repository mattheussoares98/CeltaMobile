import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/presentation/theme/app_decorations.dart';
import '../../../../../core/validators/validators.dart';
import '../../../../../localization/string_hardcoded.dart';

class EnterpriseField extends StatelessWidget {
  final TextEditingController enterpriseController;
  final FocusNode userFocusNode;
  const EnterpriseField({
    super.key,
    required this.enterpriseController,
    required this.userFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: enterpriseController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        userFocusNode.requestFocus();
      },
      validator: FormValidators.compose([NonEmptyValidator()]),
      decoration: AppDecorations.input(
        context: context,
        labelText: 'Empresa'.hardcoded,
        prefixIcon: Icon(
          theme.platform == TargetPlatform.iOS
              ? CupertinoIcons.building_2_fill
              : Icons.business,
        ),
      ),
    );
  }
}
