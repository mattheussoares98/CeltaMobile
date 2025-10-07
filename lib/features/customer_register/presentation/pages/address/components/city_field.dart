import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../address.dart';

class CityField extends StatelessWidget {
  const CityField(this.widget, {super.key});

  final AddressPage widget;

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: widget.cityController,
      enabled: false,
      labelText: 'Cidade'.hardcoded,
      hintText: 'Cidade'.hardcoded,
    );
  }
}
