import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';

class CityField extends StatelessWidget {
  final TextEditingController cityController;
  const CityField({super.key, required this.cityController});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: cityController,
      enabled: false,
      labelText: 'Cidade'.hardcoded,
      hintText: 'Cidade'.hardcoded,
    );
  }
}
