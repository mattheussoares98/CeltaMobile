import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/presentation/theme/theme.dart';
import 'components.dart';

class EnterpriseNameField extends StatelessWidget {
  final bool isLoading;
  final TextEditingController enterpriseNameController;
  final FocusNode urlFocusNode;
  const EnterpriseNameField({
    super.key,
    required this.isLoading,
    required this.enterpriseNameController,
    required this.urlFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: !isLoading,
      autofocus: true,
      controller: enterpriseNameController,
      onFieldSubmitted: (_) {
        urlFocusNode.requestFocus();
      },
      decoration: AppDecorations.input(
        //TODO use DefaultTextFormField
        context: context,
        hintText: "Nome da empresa".hardcoded,
        suffixIcon: DeleteIcon(
          onPress: isLoading ? null : enterpriseNameController.clear,
        ),
      ),
    );
  }
}
