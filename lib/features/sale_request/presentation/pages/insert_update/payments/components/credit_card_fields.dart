import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final selectedCreditCardType = ref.watch(
      selectedPaymentTypeStateControllerProvider.select(
        (s) => s?.action?.type == PaymentFinalizationActionType.creditCard,
      ),
    );

    if (!selectedCreditCardType) {
      return const SizedBox.shrink();
    }

    final now = DateTime.now();
    final children = [
      DefaultTextFormField(
        controller: creditCardController,
        labelText: 'Número do cartão'.hardcoded,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next,
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
        textInputAction: TextInputAction.next,
        validator: FormValidators.compose([
          NonEmptyValidator(),
          NumberValidator(allowDecimal: false),
        ]),
      ),
      DefaultTextFormField(
        controller: validityController,
        labelText: 'Validade'.hardcoded,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next,
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
    );
  }
}
