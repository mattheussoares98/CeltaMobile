import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class ValueFieldAndConfirmButton extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  const ValueFieldAndConfirmButton({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  ConsumerState<ValueFieldAndConfirmButton> createState() =>
      _ValueFieldAndConfirmButtonState();
}

class _ValueFieldAndConfirmButtonState
    extends ConsumerState<ValueFieldAndConfirmButton> {
  final valueController = TextEditingController();
  BSFPaymentFinalizationEntity? selectedPayment;

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
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
          ),
        ),
        gapW16,
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              return PrimaryButton(
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
                text: 'ADICIONAR'.hardcoded,
              );
            },
          ),
        ),
      ],
    );
  }
}
