import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';
import 'components.dart';

class UrlField extends StatelessWidget {
  final TextEditingController urlController;
  final FocusNode urlFocusNode;
  final bool isLoading;
  final FocusNode userNameFocusNode;
  const UrlField({
    super.key,
    required this.urlController,
    required this.urlFocusNode,
    required this.isLoading,
    required this.userNameFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      enabled: !isLoading,
      controller: urlController,
      focusNode: urlFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        userNameFocusNode.requestFocus();
      },
      labelText: "Url".hardcoded,
      hintText: "Url".hardcoded,
      suffixIcon: DeleteIcon(onPress: isLoading ? null : urlController.clear),
      validator: FormValidators.compose([UrlValidator()]),
    );
  }
}
