import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

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
    return BaseTextFormField(
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
