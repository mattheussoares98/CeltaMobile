import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../controllers/controllers.dart';

class QuantityButtonsAndField extends ConsumerWidget {
  final bool insertIndividually;
  final FocusNode quantityFocusNode;
  final TextEditingController quantityController;
  final int codigoInternoInvCont;
  final int codigoInternoProEmb;
  const QuantityButtonsAndField({
    super.key,
    required this.insertIndividually,
    required this.quantityFocusNode,
    required this.quantityController,
    required this.codigoInternoInvCont,
    required this.codigoInternoProEmb,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void entry(bool isSubtract) {
      ref
          .read(
            entryQuantityStateControllerProvider(codigoInternoInvCont).notifier,
          )
          .entry(
            codigoInternoProEmb: codigoInternoProEmb,
            quantity: insertIndividually
                ? 1
                : quantityController.text.toDouble()!,
            isSubtract: isSubtract,
          );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(Sizes.p8, Sizes.p8, Sizes.p8, 0),
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
                    entry(true);
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
                    entry(false);
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
                    onFieldSubmitted: (_) {
                      entry(false);
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
