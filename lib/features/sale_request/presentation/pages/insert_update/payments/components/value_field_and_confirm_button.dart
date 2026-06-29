import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final valueFocusNode = FocusNode();

  @override
  void dispose() {
    valueController.dispose();
    valueFocusNode.dispose();
    super.dispose();
  }

  void onTap() {
    if (widget.formKey.currentState?.validate() != true) {
      return;
    }
    primaryFocus?.unfocus();
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
          child: BaseTextFormField(
            focusNode: valueFocusNode,
            controller: valueController,
            labelText: 'Valor'.hardcoded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onFieldSubmitted: (_) => onTap(),
            autovalidateMode: AutovalidateMode.onUserInteractionIfError,
            validator: FormValidators.compose([
              NonEmptyValidator(),
              NumberValidator(allowDecimal: true, maxDecimalHouses: 2),
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
