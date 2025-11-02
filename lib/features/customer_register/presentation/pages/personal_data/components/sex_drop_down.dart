import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';

class SexDropDown extends StatelessWidget {
  final Function(CustomerSexType? value) onChangeSex;
  final CustomerSexType? selectedSex;
  const SexDropDown({
    super.key,
    required this.onChangeSex,
    required this.selectedSex,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultSimpleDropDown<CustomerSexType?>(
      value: selectedSex,
      hint: 'Sexo'.hardcoded,
      onChanged: onChangeSex,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
