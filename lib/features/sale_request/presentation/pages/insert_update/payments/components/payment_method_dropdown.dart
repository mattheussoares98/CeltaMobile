import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            children: [
              Text(context.l10n.noPaymentMethodsAreAvailableForThisOrder),
              gapH16,
              PrimaryButton(
                onPressed: () => ref.invalidate(
                  filteredPaymentFinalizationsStateControllerProvider,
                ),
                text: context.l10n.reload,
              ),
            ],
          );
        }

        final items = paymentFinalizations
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Center(child: Text(e.Description ?? '')),
              ),
            )
            .toList();

        return Consumer(
          builder: (context, ref, _) {
            final selectedPayment = ref.watch(
              selectedPaymentTypeStateControllerProvider,
            );

            return BaseDropDown<BSFPaymentFinalizationEntity>(
              selectedItem: selectedPayment,
              showLabelAtTopLeft: true,
              label: context.l10n.paymentMethod,
              validator: (_) {
                if (selectedPayment == null) {
                  return context.l10n.selectAPaymentMethod;
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
