import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../localization/string_hardcoded.dart';

class PriceField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const PriceField({
    super.key,
    required this.controller,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: controller,
      labelText: 'Preço'.hardcoded,
      enabled: enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
    );
  }
}
