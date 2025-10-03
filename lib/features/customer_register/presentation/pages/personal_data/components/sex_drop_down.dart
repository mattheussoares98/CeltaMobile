import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../personal_data.dart';

class SexDropDown extends StatelessWidget {
  final PersonalDataPage personalDataPage;
  const SexDropDown(this.personalDataPage, {super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSimpleDropDown<String?>(
      value: personalDataPage.selectedSex,
      hint: 'Sexo'.hardcoded,
      onChanged: personalDataPage.onChangeSex,
      items: ['Masculino', 'Feminino']
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Center(child: Text(e)),
            ),
          )
          .toList(),
    );
  }
}
