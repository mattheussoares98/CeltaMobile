import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';
import '../personal_data.dart';
import 'components.dart';

class NameField extends StatelessWidget {
  final PersonalDataPage personalDataPage;
  const NameField(this.personalDataPage, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: personalDataPage.nameController,
      maxLength: 50,
      hintText: 'Nome'.hardcoded,
      labelText: 'Nome'.hardcoded,
      focusNode: personalDataPage.nameFocusNode,
      validator: FormValidators.compose([
        NonEmptyValidator(),
        MinLengthValidator(3),
      ]),
      onFieldSubmitted: (_) {
        personalDataPage.reducedNameFocusNode.requestFocus();
      },
      suffixIcon: DefaultDeleteIcon(
        controller: personalDataPage.nameController,
      ),
    );
  }
}
