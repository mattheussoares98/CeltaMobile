import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../controllers/controllers.dart';

class PaymentMethodDropdown extends ConsumerWidget {
  const PaymentMethodDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(filteredPaymentFinalizationsStateControllerProvider),
      tryAgain: () =>
          ref.invalidate(filteredPaymentFinalizationsStateControllerProvider),
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
                onPressed: () => ref.invalidate(
                  filteredPaymentFinalizationsStateControllerProvider,
                ),
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
              selectedPaymentTypeStateControllerProvider,
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
                    .read(selectedPaymentTypeStateControllerProvider.notifier)
                    .select(value);
              },
            );
          },
        );
      },
    );
  }
}
