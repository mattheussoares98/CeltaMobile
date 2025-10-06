import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/presentation/theme/theme.dart';
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
    return TextFormField(
      enabled: !isLoading,
      controller: urlController,
      focusNode: urlFocusNode,
      onFieldSubmitted: (_) {
        userNameFocusNode.requestFocus();
      },
      decoration: AppDecorations.input(
        //TODO use DefaultTextFormField
        context: context,
        hintText: "Url".hardcoded,
        suffixIcon: DeleteIcon(onPress: isLoading ? null : urlController.clear),
      ),
    );
  }
}
