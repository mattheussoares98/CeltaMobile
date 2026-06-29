import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

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
    return BaseTextFormField(
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
