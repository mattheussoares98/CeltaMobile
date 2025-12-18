import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/validators/validators.dart';

class AddInLot extends ConsumerWidget {
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final VoidCallback addInLot;
  final bool productIsAlreadyInLot;
  const AddInLot({
    super.key,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.addInLot,
    required this.productIsAlreadyInLot,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Row(
      children: [
        Expanded(
          flex: 2,
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
            icon: mediaQuery.size.width < 300
                ? null
                : Icon(
                    theme.platform == TargetPlatform.iOS
                        ? CupertinoIcons.add
                        : Icons.add,
                  ),
            onPressed: addInLot,
          ),
        ),
      ],
    );
  }
}
