import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class PaymentsForm extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  const PaymentsForm({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  ConsumerState<PaymentsForm> createState() => _PaymentsFormState();
}

class _PaymentsFormState extends ConsumerState<PaymentsForm> {
  final valueController = TextEditingController();
  BSFPaymentFinalizationEntity? selectedPayment;

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        gapH16,
        DefaultTextFormField(
          controller: valueController,
          labelText: 'Valor'.hardcoded,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        gapH16,
        PrimaryButton(
          onPressed: () {
            final value = valueController.text.toDouble();
            if (selectedPayment != null && value != null && value > 0) {
              ref
                  .read(
                    insertUpdateStateControllerProvider(
                      enterpriseCode: widget.enterpriseCode,
                      customerCode: widget.customerCode,
                      saleRequestId: widget.saleRequestId,
                    ).notifier,
                  )
                  .addPayment(payment: selectedPayment!, value: value);
              valueController.clear();
            }
          },
          text: 'ADICIONAR PAGAMENTO'.hardcoded,
        ),
      ],
    );
  }
}
