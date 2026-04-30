import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../localization/string_hardcoded.dart';

class ObservationsField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const ObservationsField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: controller,
      focusNode: focusNode,
      labelText: 'Observações'.hardcoded,
      maxLines: 3,
      maxLength: 200,
      textInputAction: TextInputAction.done,
    );
  }
}
