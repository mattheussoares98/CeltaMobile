import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';

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
          child: DefaultTextFormField(
            controller: quantityController,
            maxLength: 14,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            focusNode: quantityFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onFieldSubmitted: (_) {
              addInLot();
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
            text: productIsAlreadyInLot
                ? 'Alterar'.hardcoded
                : 'Lote'.hardcoded,
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
