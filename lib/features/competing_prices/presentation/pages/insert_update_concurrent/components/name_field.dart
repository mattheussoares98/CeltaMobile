import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../../../localization/string_hardcoded.dart';

class NameField extends StatelessWidget {
  final TextEditingController nameController;
  final FocusNode observationFocusNode;
  const NameField({
    super.key,
    required this.nameController,
    required this.observationFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: nameController,
      labelText: 'Nome'.hardcoded,
      hintText: 'Nome'.hardcoded,
      onFieldSubmitted: (_) => observationFocusNode.requestFocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 50,
      validator: FormValidators.compose([NonEmptyValidator()]),
    );
  }
}
