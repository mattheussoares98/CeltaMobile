import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/validators/validators.dart';

class ConfirmAdjustStock extends ConsumerWidget {
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final VoidCallback onConfirm;
  const ConfirmAdjustStock({
    super.key,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DefaultTextFormField(
            controller: quantityController,
            maxLength: 10,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            focusNode: quantityFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onFieldSubmitted: (_) {
              onConfirm();
            },
            hintText: "Quantidade".hardcoded,
            labelText: "Quantidade".hardcoded,
            validator: FormValidators.compose([
              NonEmptyValidator(),
              NumberValidator(allowDecimal: true, maxDecimalHouses: 3),
            ]),
          ),
        ),
        gapW8,
        Expanded(
          child: PrimaryButton(
            text: 'Confirmar'.hardcoded,
            onPressed: onConfirm,
          ),
        ),
      ],
    );
  }
}
