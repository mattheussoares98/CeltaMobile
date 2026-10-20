import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return BaseTextFormField(
      controller: controller,
      focusNode: focusNode,
      hintText: context.l10n.replacementCost,
      labelText: context.l10n.replacementCost,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      maxLength: 12,
      onFieldSubmitted: (_) => onSubmit(),
      validator: FormValidators.compose([
        NonEmptyValidator(translations: context.l10n),
        NumberValidator(
          translations: context.l10n,
          allowDecimal: true,
          allowEmptyValue: false,
          needsBeGreaterThanZero: false,
          maxDecimalHouses: 4,
        ),
      ]),
    );
  }
}
