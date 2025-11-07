import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';

class ObservationsField extends StatelessWidget {
  final FocusNode observationsFocusNode;
  final TextEditingController observationsController;
  final FocusNode instructionsFocusNode;
  const ObservationsField({
    super.key,
    required this.observationsFocusNode,
    required this.observationsController,
    required this.instructionsFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      labelText: 'Observações'.hardcoded,
      hintText: 'Observações'.hardcoded,
      maxLines: 3,
      maxLength: 300,
      focusNode: observationsFocusNode,
      controller: observationsController,
      onFieldSubmitted: (_) {
        instructionsFocusNode.requestFocus();
      },
    );
  }
}
