import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../commom_widgets/commom_widgets.dart';

class ComplementField extends StatelessWidget {
  final TextEditingController complementController;
  final FocusNode complementFocusNode;
  final FocusNode referenceFocusNode;
  const ComplementField({
    super.key,
    required this.isLoading,
    required this.complementController,
    required this.complementFocusNode,
    required this.referenceFocusNode,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      enabled: !isLoading,
      controller: complementController,
      focusNode: complementFocusNode,
      labelText: 'Complemento'.hardcoded,
      hintText: 'Complemento'.hardcoded,
      onFieldSubmitted: (_) {
        referenceFocusNode.requestFocus();
      },
    );
  }
}
