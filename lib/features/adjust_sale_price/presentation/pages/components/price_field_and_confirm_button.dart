import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/validators/validators.dart';

class PriceFieldAndConfirmButton extends ConsumerWidget {
  final TextEditingController priceController;
  const PriceFieldAndConfirmButton({super.key, required this.priceController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.p8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DefaultTextFormField(
              controller: priceController,
              maxLength: 10,
              hintText: "Preço".hardcoded,
              labelText: "Preço".hardcoded,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (_) {
                //TODO implement
              },
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
                //TODO test in iOS
              ),
              validator: FormValidators.compose([
                NonEmptyValidator(),
                NumberValidator(allowDecimal: true),
              ]),
            ),
          ),
          gapW8,
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: Sizes.p8),
                child: PrimaryButton(
                  text: 'Confirmar'.hardcoded,
                  onPressed: () {
                    //TODO create a controller and use in this page
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
