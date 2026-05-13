import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../controllers/controllers.dart';

class ValueFieldAndConfirmButton extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController creditCardController;
  final TextEditingController portionsController;
  final TextEditingController validityController;

  const ValueFieldAndConfirmButton({
    super.key,
    required this.formKey,
    required this.creditCardController,
    required this.portionsController,
    required this.validityController,
  });

  @override
  ConsumerState<ValueFieldAndConfirmButton> createState() =>
      _ValueFieldAndConfirmButtonState();
}

class _ValueFieldAndConfirmButtonState
    extends ConsumerState<ValueFieldAndConfirmButton> {
  final valueController = TextEditingController();

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }

  void onTap() {
    if (widget.formKey.currentState?.validate() != true) {
      return;
    }

    final selectedPayment = ref.read(
      selectedPaymentTypeStateControllerProvider,
    );

    if (selectedPayment == null) {
      return;
    }

    final value = valueController.text.toDouble();
    if (value != null && value > 0) {
      final (succeeds, error) = ref
          .read(insertUpdateStateControllerProvider.notifier)
          .addPayment(
            payment: selectedPayment,
            value: value,
            creditCardProperties: CreditCardPropertiesEntity(
              creditCardNumber: widget.creditCardController.text,
              creditCardValidate: widget.validityController.text.toDateTime(),
              quantityOfPortions:
                  int.tryParse(widget.portionsController.text) ?? 1,
            ),
          );
      if (succeeds) {
        valueController.clear();
        widget.creditCardController.clear();
        widget.portionsController.clear();
        widget.validityController.clear();
      } else {
        showSnackBarMessage(
          context,
          error ?? 'Erro ao adicionar pagamento'.hardcoded,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: DefaultTextFormField(
            controller: valueController,
            labelText: 'Valor'.hardcoded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onFieldSubmitted: (_) => onTap(),
            validator: FormValidators.compose([
              NonEmptyValidator(),
              NumberValidator(allowDecimal: true),
            ]),
          ),
        ),
        gapW16,
        Expanded(
          child: PrimaryButton(onPressed: onTap, text: 'ADICIONAR'.hardcoded),
        ),
      ],
    );
  }
}
