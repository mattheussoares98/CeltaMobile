import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../pages.dart';
import 'components.dart';

class InscriptionField extends StatelessWidget {
  final PersonalDataPage personalDataPage;
  const InscriptionField(this.personalDataPage, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: personalDataPage.inscriptionController,
      focusNode: personalDataPage.inscriptionFocusNode,
      maxLength: 9,
      hintText: 'Inscrição estadual'.hardcoded,
      labelText: 'Inscrição estadual'.hardcoded,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        personalDataPage.nameFocusNode.requestFocus();
      },
      suffixIcon: DefaultDeleteIcon(
        controller: personalDataPage.inscriptionController,
      ),
    );
  }
}
