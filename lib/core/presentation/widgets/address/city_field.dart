import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:flutter/material.dart';

class CityField extends StatelessWidget {
  final TextEditingController cityController;
  const CityField({super.key, required this.cityController});

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      controller: cityController,
      enabled: false,
      labelText: context.l10n.city,
      hintText: context.l10n.city,
    );
  }
}
