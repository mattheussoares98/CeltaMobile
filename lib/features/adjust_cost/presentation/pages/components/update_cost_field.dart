import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';

class UpdateCostField extends ConsumerWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmit;
  const UpdateCostField({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTextFormField(
      controller: controller,
      focusNode: focusNode,
      hintText: 'Custo de reposição'.hardcoded,
      labelText: 'Custo de reposição'.hardcoded,
      autofocus: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      maxLength: 12,
      onFieldSubmitted: (_) => onSubmit(),
      validator: FormValidators.compose([
        NonEmptyValidator(),
        NumberValidator(
          allowDecimal: true,
          allowEmptyValue: false,
          needsBeGreaterThanZero: false,
          maxDecimalHouses: 4,
        ),
      ]),
    );
  }
}
