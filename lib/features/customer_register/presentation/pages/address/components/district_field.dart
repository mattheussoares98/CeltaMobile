import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../address.dart';

class DistrictField extends StatelessWidget {
  const DistrictField(this.widget, {super.key});

  final AddressPage widget;

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: widget.districtController,
      enabled: false,
      labelText: 'Bairro'.hardcoded,
      hintText: 'Bairro'.hardcoded,
    );
  }
}
