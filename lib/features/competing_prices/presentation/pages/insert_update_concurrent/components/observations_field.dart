import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';

class ObservationsField extends StatelessWidget {
  final FocusNode observationFocusNode;
  final TextEditingController observationController;
  final VoidCallback insertUpdate;
  const ObservationsField({
    super.key,
    required this.observationFocusNode,
    required this.observationController,
    required this.insertUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: observationController,
      focusNode: observationFocusNode,
      labelText: 'Observações'.hardcoded,
      hintText: 'Observações'.hardcoded,
      onFieldSubmitted: (_) => insertUpdate(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 200,
    );
  }
}
