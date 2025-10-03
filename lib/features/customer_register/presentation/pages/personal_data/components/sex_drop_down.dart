import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';

class SexDropDown extends StatelessWidget {
  final String? selectedSex;
  const SexDropDown({super.key, required this.selectedSex});

  @override
  Widget build(BuildContext context) {
    return DefaultSimpleDropDown<String?>(
      value: selectedSex,
      hint: 'Sexo'.hardcoded,
      onChanged: (_) {},
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
