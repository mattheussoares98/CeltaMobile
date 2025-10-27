import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/validators/validators.dart';

class QuantityFieldAndInsertButton extends ConsumerWidget {
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;

  const QuantityFieldAndInsertButton({
    super.key,
    required this.quantityController,
    required this.quantityFocusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DefaultTextFormField(
            controller: quantityController,
            focusNode: quantityFocusNode,
            labelText: 'Quantidade'.hardcoded,
            hintText: 'Quantidade'.hardcoded,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onFieldSubmitted: (_) {},
            maxLength: 13,
            onTap: () {
              quantityController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: quantityController.text.length,
              );
            },
            validator: FormValidators.compose([
              NonEmptyValidator(),
              NumberValidator(allowDecimal: true),
            ]),
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
              //TODO test in iOS
            ),
          ),
        ),
        gapW8,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Text('Total'.hardcoded)),
              PrimaryButton(
                text: 'Adicionar'.hardcoded,
                icon: Icon(
                  isIOS ? CupertinoIcons.shopping_cart : Icons.shopping_cart,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
