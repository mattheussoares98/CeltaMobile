import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../personal_data.dart';
import 'components.dart';

class ReducedNameField extends StatelessWidget {
  final PersonalDataPage personalDataPage;
  const ReducedNameField(this.personalDataPage, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: personalDataPage.reducedNameController,
      maxLength: 30,
      hintText: 'Nome reduzido'.hardcoded,
      labelText: 'Nome reduzido'.hardcoded,
      focusNode: personalDataPage.reducedNameFocusNode,
      onFieldSubmitted: (_) {
        personalDataPage.passwordFocusNode.requestFocus();
      },
      suffixIcon: DefaultDeleteIcon(
        controller: personalDataPage.reducedNameController,
      ),
    );
  }
}
