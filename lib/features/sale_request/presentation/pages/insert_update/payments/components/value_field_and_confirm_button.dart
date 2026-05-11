import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../controllers/controllers.dart';

class ValueFieldAndConfirmButton extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  final GlobalKey<FormState> formKey;
  final VoidCallback onConfirm;

  const ValueFieldAndConfirmButton({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
    required this.formKey,
    required this.onConfirm,
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
      selectedPaymentTypeStateControllerProvider(widget.saleRequestId),
    );

    if (selectedPayment == null) {
      return;
    }

    final value = valueController.text.toDouble();
    if (value != null && value > 0) {
      ref
          .read(
            insertUpdateStateControllerProvider(
              enterpriseCode: widget.enterpriseCode,
              customerCode: widget.customerCode,
              saleRequestId: widget.saleRequestId,
            ).notifier,
          )
          .addPayment(payment: selectedPayment, value: value);
      valueController.clear();
      widget.onConfirm.call();
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
            validator: FormValidators.compose([
              NonEmptyValidator(),
              NumberValidator(allowDecimal: true),
            ]),
          ),
        ),
        gapW16,
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              return PrimaryButton(
                onPressed: onTap,
                text: 'ADICIONAR'.hardcoded,
              );
            },
          ),
        ),
      ],
    );
  }
}
