import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentsList extends ConsumerWidget {
  const PaymentsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financialsAsync = ref.watch(
      insertUpdateStateControllerProvider.select(
        (v) => v.whenData((data) => data.financials),
      ),
    );

    final missingPayment = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) => s.value?.isPaymentValid != true,
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

        final color = context.theme.disabledColor.withAlpha(30);

        return SliverList.separated(
          itemCount: payments.length,
          separatorBuilder: (context, index) => gapH8,
          itemBuilder: (context, index) {
            final payment = payments[index];

            return Column(
              children: [
                if (index == 0) ...[
                  if (missingPayment) const Divider(),
                  Text(
                    'Pagamentos informados'.hardcoded,
                    style: context.theme.textTheme.titleMedium,
                  ),
                  gapH8,
                ],
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.p12),
                    side: BorderSide(
                      color: context.theme.disabledColor.withAlpha(30),
                    ),
                  ),
                  tileColor: index % 2 == 0 ? color : null,
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
                ),
              ],
            );
          },
        );
      },
      tryAgain: () => ref.invalidate(insertUpdateStateControllerProvider),
    );
  }
}
