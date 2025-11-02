import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import 'components.dart';

class InscriptionField extends StatelessWidget {
  final TextEditingController inscriptionController;
  final FocusNode inscriptionFocusNode;
  final FocusNode nameFocusNode;
  const InscriptionField({
    super.key,
    required this.inscriptionController,
    required this.inscriptionFocusNode,
    required this.nameFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: inscriptionController,
      focusNode: inscriptionFocusNode,
      maxLength: 9,
      hintText: 'Inscrição estadual'.hardcoded,
      labelText: 'Inscrição estadual'.hardcoded,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        nameFocusNode.requestFocus();
      },
      suffixIcon: DefaultDeleteIcon(controller: inscriptionController),
    );
  }
}
