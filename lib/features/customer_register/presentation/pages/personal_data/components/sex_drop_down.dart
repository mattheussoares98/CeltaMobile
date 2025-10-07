import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../personal_data.dart';

class SexDropDown extends StatelessWidget {
  final PersonalDataPage personalDataPage;
  const SexDropDown(this.personalDataPage, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSimpleDropDown<CustomerSexType?>(
      value: personalDataPage.selectedSex,
      hint: 'Sexo'.hardcoded,
      onChanged: personalDataPage.onChangeSex,
      validator: (sex) {
        if (sex == null) {
          return 'Campo obrigatório'.hardcoded;
        }
        return null;
      },
      items: CustomerSexType.values
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Center(child: Text(e.name)),
            ),
          )
          .toList(),
    );
  }
}
