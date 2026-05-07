import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';

class CreditCardFields extends ConsumerWidget {
  final TextEditingController creditCardController;
  final TextEditingController portionsController;
  final TextEditingController validityController;

  const CreditCardFields({
    super.key,
    required this.creditCardController,
    required this.portionsController,
    required this.validityController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();

    return Column(
      children: [
        DefaultTextFormField(
          controller: creditCardController,
          labelText: 'Número do cartão'.hardcoded,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            CreditCardNumberInputFormatter(),
          ],
        ),
        DefaultTextFormField(
          controller: portionsController,
          labelText: 'Parcelas'.hardcoded,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: FormValidators.compose([
            NonEmptyValidator(),
            NumberValidator(allowDecimal: false),
          ]),
        ),
        DefaultTextFormField(
          controller: validityController,
          labelText: 'Validade'.hardcoded,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [DateInputFormatter(includeDay: false)],
          validator: FormValidators.compose([
            DateValidator(
              minimumDate: now,
              maximumDate: now.add(const Duration(days: 365 * 10)),
              includeDay: false,
            ),
          ]),
        ),
      ],
    );
  }
}
