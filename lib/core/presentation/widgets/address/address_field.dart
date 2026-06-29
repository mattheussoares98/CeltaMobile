import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class AddressField extends StatelessWidget {
  final TextEditingController addressController;
  const AddressField({super.key, required this.addressController});

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      controller: addressController,
      enabled: false,
      labelText: 'Logradouro'.hardcoded,
      hintText: 'Logradouro'.hardcoded,
    );
  }
}
