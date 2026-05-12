import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../controllers/controllers.dart';

class PaymentMethodDropdown extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestCode;
  const PaymentMethodDropdown({
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestCode,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentProvider = filteredPaymentFinalizationsStateControllerProvider(
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
      saleRequestCode: saleRequestCode,
    );

    return AsyncValueWidget(
      value: ref.watch(paymentProvider),
      tryAgain: () => ref.invalidate(paymentProvider),
      data: (paymentFinalizations) {
        if (paymentFinalizations.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Nenhuma forma de pagamento está disponível para este pedido.'
                    .hardcoded,
              ),
              gapH16,
              PrimaryButton(
                onPressed: () => ref.invalidate(paymentProvider),
                text: 'Carregar novamente'.hardcoded,
              ),
            ],
          );
        }

        final items = paymentFinalizations
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      text: e.Description,
                      children: [
                        if (e.paymentForm?.name != null)
                          TextSpan(text: ' - ${e.paymentForm!.name}'),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList();

        return Consumer(
          builder: (context, ref, _) {
            final selectedPayment = ref.watch(
              selectedPaymentTypeStateControllerProvider(saleRequestCode),
            );

            return DefaultDropDown<BSFPaymentFinalizationEntity>(
              selectedItem: selectedPayment,
              label: 'Forma de Pagamento'.hardcoded,
              hint: Text('Selecionar'.hardcoded),
              validator: (_) {
                if (selectedPayment == null) {
                  return 'Selecione uma forma de pagamento'.hardcoded;
                }
                return null;
              },
              items: items,
              onChanged: (value) {
                ref
                    .read(
                      selectedPaymentTypeStateControllerProvider(
                        saleRequestCode,
                      ).notifier,
                    )
                    .select(value);
              },
            );
          },
        );
      },
    );
  }
}
