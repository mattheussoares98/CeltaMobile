import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:flutter/material.dart';

class AddressField extends StatelessWidget {
  final TextEditingController addressController;
  const AddressField({super.key, required this.addressController});

  @override
  Widget build(BuildContext context) {
    return BaseTextFormField(
      controller: addressController,
      enabled: false,
      labelText: context.l10n.street,
      hintText: context.l10n.street,
    );
  }
}
