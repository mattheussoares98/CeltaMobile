import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/validators/validators.dart';

class PriceFieldAndConfirmButton extends ConsumerWidget {
  final TextEditingController priceController;
  final void Function()? onPressed;
  final bool isLoading;
  const PriceFieldAndConfirmButton({
    super.key,
    required this.priceController,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.p8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 65,
            child: DefaultTextFormField(
              controller: priceController,
              maxLength: 10,
              hintText: "Novo preço".hardcoded,
              labelText: "Novo preço".hardcoded,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (_) {
                onPressed?.call();
              },
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
                //TODO test in iOS
              ),
              validator: FormValidators.compose([
                NonEmptyValidator(),
                NumberValidator(
                  allowDecimal: true,
                  needsBeGreaterThanZero: false,
                ),
              ]),
            ),
          ),
          gapW8,
          Expanded(
            flex: 35,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: Sizes.p8),
                  child: PrimaryButton(
                    text: 'Confirmar'.hardcoded,
                    onPressed: onPressed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
