import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../localization/string_hardcoded.dart';

class QuantityField extends StatelessWidget {
  final TextEditingController controller;

  const QuantityField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: controller,
      labelText: 'Quantidade'.hardcoded,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
    );
  }
}
