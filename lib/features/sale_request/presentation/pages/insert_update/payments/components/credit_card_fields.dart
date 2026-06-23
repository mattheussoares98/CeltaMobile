import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreditCardFields extends ConsumerStatefulWidget {
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
  ConsumerState<CreditCardFields> createState() => CreditCardFieldsState();
}

class CreditCardFieldsState extends ConsumerState<CreditCardFields> {
  final cardNumberFocusNode = FocusNode();
  final portionsFocusNode = FocusNode();
  final validityFocusNode = FocusNode();

  @override
  void dispose() {
    cardNumberFocusNode.dispose();
    portionsFocusNode.dispose();
    validityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCreditCardType = ref.watch(
      selectedPaymentTypeStateControllerProvider.select(
        (s) => s?.action?.type == PaymentFinalizationActionType.creditCard,
      ),
    );

    if (!selectedCreditCardType) {
      return const SizedBox.shrink();
    }

    final now = DateTime.now();

    return Column(
      children: [
        DefaultTextFormField(
          focusNode: cardNumberFocusNode,
          controller: widget.creditCardController,
          labelText: 'Número do cartão'.hardcoded,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            CreditCardNumberInputFormatter(),
          ],
        ),
        DefaultTextFormField(
          focusNode: portionsFocusNode,
          controller: widget.portionsController,
          labelText: 'Qtd parcelas'.hardcoded,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.next,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          validator: FormValidators.compose([
            NonEmptyValidator(),
            NumberValidator(allowDecimal: false),
          ]),
        ),
        DefaultTextFormField(
          focusNode: validityFocusNode,
          controller: widget.validityController,
          labelText: 'Validade'.hardcoded,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
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
      ],
    );
  }
}
