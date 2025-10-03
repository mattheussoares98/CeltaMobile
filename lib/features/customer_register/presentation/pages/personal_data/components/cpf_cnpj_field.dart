import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/validators/validators.dart';
import '../../pages.dart';
import 'components.dart';

class CpfCnpjField extends StatelessWidget {
  final PersonalDataPage personalDataPage;
  const CpfCnpjField(this.personalDataPage, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: personalDataPage.cpfCnpjController,
      maxLength: 14,
      hintText: 'CPF/CNPJ'.hardcoded,
      labelText: 'CPF/CNPJ'.hardcoded,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        personalDataPage.nameFocusNode.requestFocus();
      },
      validator: FormValidators.compose([
        NonEmptyValidator(),
        CpfCnpjValidator(),
      ]),
      onChanged: (_) {
        personalDataPage.onChangeCpfCnpj();
      },
      suffixIcon: DefaultDeleteIcon(
        controller: personalDataPage.cpfCnpjController,
      ),
    );
  }
}
