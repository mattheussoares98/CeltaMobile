import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';

class PaymentsList extends ConsumerWidget {
  const PaymentsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financialsAsync = ref.watch(
      insertUpdateStateControllerProvider.select(
        (v) => v.whenData((data) => data.financials),
      ),
    );

    return AsyncValueWidget(
      value: financialsAsync,
      isSliver: true,
      data: (financials) {
        final payments =
            financials
                ?.expand(
                  (f) =>
                      f.paymentFinalizations ??
                      <BSFPaymentFinalizationWrapperEntity>[],
                )
                .toList() ??
            <BSFPaymentFinalizationWrapperEntity>[];

        if (payments.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Nenhum pagamento adicionado'.hardcoded)),
          );
        }

        return SliverList.separated(
          itemCount: payments.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final payment = payments[index];
            return ListTile(
              title: TitleAndSubTitle(
                title: payment.paymentFinalization?.Description ?? '',
                subTitle:
                    (payment.quantityOfPortions ?? 0) > 1 ||
                        payment.paymentFinalization?.action?.type ==
                            PaymentFinalizationActionType.creditCard
                    ? "(${payment.quantityOfPortions ?? ''}x)"
                    : "",
                removeColon: true,
              ),
              subtitle: Text(
                payment.value
                        ?.toString()
                        .toBrazilianNumber()
                        .addBrazilianCoin() ??
                    '',
              ),
              trailing: IconButton(
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.delete,
                  materialIcon: Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () => ref
                    .read(insertUpdateStateControllerProvider.notifier)
                    .removePayment(index),
              ),
            );
          },
        );
      },
      tryAgain: () => ref.invalidate(insertUpdateStateControllerProvider),
    );
  }
}
