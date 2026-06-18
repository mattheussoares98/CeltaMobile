import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncrementAndDiscount extends ConsumerWidget {
  const IncrementAndDiscount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Consumer(
          builder: (_, ref, _) {
            final (
              allowUpdate,
              financialIncrement,
              financialIncrementValue,
            ) = ref.watch(
              insertUpdateStateControllerProvider.select(
                (s) => (
                  s.value?.requestType?.allowFinancialIncrement ?? false,
                  s.value?.financialIncrement,
                  s.value?.financialIncrementValue,
                ),
              ),
            );

            return ManageDiscountOrIncrement(
              valueTypes: [financialIncrement],
              allowUpdate: allowUpdate,
              title: 'Acréscimo financeiro'.hardcoded,
              onUpdate: ref
                  .read(insertUpdateStateControllerProvider.notifier)
                  .updateFinancialIncrement,
              onRemove: ref
                  .read(insertUpdateStateControllerProvider.notifier)
                  .removeFinancialIncrement,
              notAllowedMessage:
                  'Esse modelo de pedido não permite acréscimo financeiro.'
                      .hardcoded,
              liquidValue: financialIncrementValue,
            );
          },
        ),
        Consumer(
          builder: (_, ref, _) {
            final (allowUpdate, financialDiscount, financialDiscountValue) = ref
                .watch(
                  insertUpdateStateControllerProvider.select(
                    (s) => (
                      s.value?.requestType?.allowFinancialDiscount ?? false,
                      s.value?.financialDiscount,
                      s.value?.financialDiscountValue,
                    ),
                  ),
                );

            return ManageDiscountOrIncrement(
              valueTypes: [financialDiscount],
              allowUpdate: allowUpdate,
              title: 'Desconto financeiro'.hardcoded,
              onUpdate: ref
                  .read(insertUpdateStateControllerProvider.notifier)
                  .updateFinancialDiscount,
              onRemove: ref
                  .read(insertUpdateStateControllerProvider.notifier)
                  .removeFinancialDiscount,
              notAllowedMessage:
                  'Esse modelo de pedido não permite desconto financeiro.'
                      .hardcoded,
              liquidValue: financialDiscountValue,
            );
          },
        ),
      ],
    );
  }
}
