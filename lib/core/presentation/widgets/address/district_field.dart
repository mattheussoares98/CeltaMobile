import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class DistrictField extends StatelessWidget {
  final TextEditingController districtController;
  const DistrictField({super.key, required this.districtController});

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      controller: districtController,
      enabled: false,
      labelText: 'Bairro'.hardcoded,
      hintText: 'Bairro'.hardcoded,
    );
  }
}
