import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
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
      labelText: context.l10n.name,
      hintText: context.l10n.name,
      onFieldSubmitted: (_) => observationFocusNode.requestFocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormValidators.compose([
        NonEmptyValidator(translations: context.l10n),
      ]),
    );
  }
}
