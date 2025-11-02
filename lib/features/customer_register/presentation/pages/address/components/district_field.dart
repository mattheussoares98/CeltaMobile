import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';

class DistrictField extends StatelessWidget {
  final TextEditingController districtController;
  const DistrictField({super.key, required this.districtController});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: districtController,
      enabled: false,
      labelText: 'Bairro'.hardcoded,
      hintText: 'Bairro'.hardcoded,
    );
  }
}
