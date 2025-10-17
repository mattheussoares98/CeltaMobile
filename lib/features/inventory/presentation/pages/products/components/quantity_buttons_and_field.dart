import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/validators/validators.dart';

class QuantityButtonsAndField extends ConsumerWidget {
  final bool insertIndividually;
  final FocusNode quantityFocusNode;
  final TextEditingController quantityController;
  const QuantityButtonsAndField({
    super.key,
    required this.insertIndividually,
    required this.quantityFocusNode,
    required this.quantityController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: PrimaryButton(
                  text:
                      '${'Subtrair'.toUpperCase().hardcoded}${insertIndividually ? " 1" : ""}',
                  onPressed: () {
                    //TODO subtract
                  },
                ),
              ),
              gapW8,
              Expanded(
                flex: 6,
                child: PrimaryButton(
                  text:
                      '${'Somar'.toUpperCase().hardcoded}${insertIndividually ? " 1" : ""}',
                  onPressed: () {
                    //TODO add
                  },
                ),
              ),
            ],
          ),
          gapH8,
          if (!insertIndividually)
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DefaultTextFormField(
                    focusNode: quantityFocusNode,
                    controller: quantityController,
                    labelText: 'Quantidade'.hardcoded,
                    hintText: 'Quantidade'.hardcoded,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormValidators.compose([
                      NonEmptyValidator(),
                      NumberValidator(allowDecimal: true),
                    ]),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                      //TODO test in iOS
                    ),
                    maxLength: 10,
                    onFieldSubmitted: (value) {
                      //TODO send quantity
                    },
                  ),
                ),
                gapW8,
                Expanded(
                  child: PrimaryButton(
                    text: 'Anular',
                    backgroundColor: Colors.red,
                    onPressed: () {
                      //TODO send anull quantity
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
