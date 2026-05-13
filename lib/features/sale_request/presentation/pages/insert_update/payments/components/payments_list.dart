import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../controllers/controllers.dart';

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
