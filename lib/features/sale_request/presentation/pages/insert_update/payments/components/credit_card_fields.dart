import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class CreditCardFields extends ConsumerWidget {
  final TextEditingController creditCardController;
  final TextEditingController portionsController;
  final TextEditingController validityController;
  final int saleRequestId;

  const CreditCardFields({
    super.key,
    required this.creditCardController,
    required this.portionsController,
    required this.validityController,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCreditCardType = ref.watch(
      selectedPaymentTypeStateControllerProvider(saleRequestId).select(
        (s) => s?.action?.type == PaymentFinalizationActionType.creditCard,
      ),
    );

    if (!selectedCreditCardType) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final now = DateTime.now();
    final children = [
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
        labelText: 'Qtd parcelas'.hardcoded,
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
            allowEmptyDate: true,
          ),
        ]),
      ),
    ];
    return ResponsiveListFlow(
      itemCount: children.length,
      isSliver: true,
      itemBuilder: (context, index) {
        return children[index];
      },
    );
  }
}
