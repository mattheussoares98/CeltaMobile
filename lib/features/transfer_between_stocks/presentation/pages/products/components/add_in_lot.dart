import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddInLot extends ConsumerWidget {
  final VoidCallback addInLot;
  final bool productIsAlreadyInLot;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  const AddInLot({
    super.key,
    required this.addInLot,
    required this.productIsAlreadyInLot,
    required this.quantityController,
    required this.quantityFocusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaSize = MediaQuery.sizeOf(context);

    return Row(
      children: [
        Expanded(
          child: BaseTextFormField(
            controller: quantityController,
            maxLength: 14,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            focusNode: quantityFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onFieldSubmitted: (_) {
              addInLot();
            },
            hintText: context.l10n.quantity,
            labelText: context.l10n.quantity,
            validator: FormValidators.compose([
              NonEmptyValidator(translations: context.l10n),
              NumberValidator(
                translations: context.l10n,
                allowDecimal: true,
                maxDecimalHouses: 3,
              ),
            ]),
          ),
        ),
        gapW8,
        Expanded(
          child: PrimaryButton(
            text: productIsAlreadyInLot
                ? context.l10n.change
                : context.l10n.batch,
            icon: mediaSize.width < 300
                ? null
                : const PlatformIcon(
                    cupertinoIcon: CupertinoIcons.add,
                    materialIcon: Icons.add,
                  ),
            iconAlignment: IconAlignment.end,
            onPressed: addInLot,
          ),
        ),
      ],
    );
  }
}
