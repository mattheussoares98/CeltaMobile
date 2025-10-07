import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../address.dart';

class AddressField extends StatelessWidget {
  const AddressField(this.page, {super.key});

  final AddressPage page;

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: page.addressController,
      enabled: false,
      labelText: 'Logradouro'.hardcoded,
      hintText: 'Logradouro'.hardcoded,
    );
  }
}
