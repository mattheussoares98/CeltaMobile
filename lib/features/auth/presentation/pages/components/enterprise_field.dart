import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/validators/validators.dart';
import '../../../../../localization/string_hardcoded.dart';

class EnterpriseField extends StatelessWidget {
  final TextEditingController enterpriseController;
  final FocusNode userFocusNode;
  final bool isLoading;
  const EnterpriseField({
    super.key,
    required this.enterpriseController,
    required this.userFocusNode,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTextFormField(
      controller: enterpriseController,
      enabled: !isLoading,
      labelText: 'Empresa'.hardcoded,
      maxLength: 25,
      prefixIcon: Icon(
        theme.platform == TargetPlatform.iOS
            ? CupertinoIcons.building_2_fill
            : Icons.business,
        color: isLoading ? theme.disabledColor : null,
      ),
      onFieldSubmitted: (_) => userFocusNode.requestFocus(),
      validator: FormValidators.compose([NonEmptyValidator()]),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
