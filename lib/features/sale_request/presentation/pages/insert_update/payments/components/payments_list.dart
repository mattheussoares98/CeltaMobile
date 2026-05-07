import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class PaymentsList extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;

  const PaymentsList({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = insertUpdateStateControllerProvider(
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
      saleRequestId: saleRequestId,
    );

    final financialsAsync = ref.watch(
      provider.select((v) => v.whenData((data) => data.financials)),
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
          return Center(child: Text('Nenhum pagamento adicionado'.hardcoded));
        }

        return SliverList.separated(
          itemCount: payments.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final payment = payments[index];
            return ListTile(
              title: TitleAndSubTitle(
                title: payment.paymentFinalization?.Description ?? '',
                subTitle: (payment.quantityOfPortions ?? 0) > 1
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
                onPressed: () =>
                    ref.read(provider.notifier).removePayment(index),
              ),
            );
          },
        );
      },
      tryAgain: () => ref.invalidate(provider),
    );
  }
}
