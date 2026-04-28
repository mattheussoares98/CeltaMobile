import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../localization/string_hardcoded.dart';

class ObservationsField extends StatelessWidget {
  final TextEditingController controller;

  const ObservationsField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: controller,
      labelText: 'Observações'.hardcoded,
      maxLines: 3,
      maxLength: 200,
    );
  }
}
