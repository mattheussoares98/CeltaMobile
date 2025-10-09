import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
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
    return DefaultTextFormField(
      enabled: !isLoading,
      controller: enterpriseNameController,
      onFieldSubmitted: (_) {
        urlFocusNode.requestFocus();
      },
      suffixIcon: DeleteIcon(
        onPress: isLoading ? null : enterpriseNameController.clear,
      ),
      hintText: "Nome da empresa".hardcoded,
      labelText: "Nome da empresa".hardcoded,
    );
  }
}
