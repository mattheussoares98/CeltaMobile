import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          child: BaseTextFormField(
            controller: quantityController,
            maxLength: 10,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            focusNode: quantityFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onFieldSubmitted: (_) {
              onConfirm();
            },
            hintText: context.l10n.quantity,
            labelText: context.l10n.quantity,
            validator: FormValidators.compose([
              NonEmptyValidator(translations: context.l10n),
              NumberValidator(
                translations: context.l10n,
                allowDecimal: true,
                maxDecimalHouses: 3,
                needsBeGreaterThanZero: false,
              ),
            ]),
          ),
        ),
        gapW8,
        Expanded(
          child: PrimaryButton(
            text: context.l10n.confirm,
            onPressed: onConfirm,
          ),
        ),
      ],
    );
  }
}
