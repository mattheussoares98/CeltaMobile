import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Financial extends ConsumerWidget {
  const Financial({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (loading, financials, hasValue) = ref.watch(
      saleRequestDetailsStateControllerProvider(
        ref.read(saleRequestArgsProvider),
      ).select((s) => (s.isLoading, s.value?.financials, s.hasValue)),
    );

    if (!hasValue || loading) {
      return const SizedBox.shrink();
    }
    final bool isFinancialEmpty = financials?.isEmpty ?? true;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          children: [
            Row(
              children: [
                PlatformIcon(
                  cupertinoIcon: CupertinoIcons.creditcard,
                  materialIcon: Icons.credit_card,
                  color: isFinancialEmpty ? Colors.red : null,
                ),
                gapW8,
                Flexible(
                  child: Text(
                    isFinancialEmpty
                        ? context.l10n.noPaymentDetails
                        : context.l10n.paymentDetails,
                    style: context.theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isFinancialEmpty
                          ? FontWeight.bold
                          : FontWeight.w300,
                      color: isFinancialEmpty ? Colors.red : null,
                    ),
                  ),
                ),
              ],
            ),
            if (!isFinancialEmpty)
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: financials!.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, fIndex) {
                  final financial = financials[fIndex];

                  return Wrap(
                    spacing: Sizes.p4,
                    runSpacing: Sizes.p4,
                    children: [
                      for (
                        var pIndex = 0;
                        pIndex < (financial.paymentFinalizations?.length ?? 0);
                        pIndex++
                      )
                        Builder(
                          builder: (context) {
                            final payment =
                                financial.paymentFinalizations![pIndex];
                            final discount = payment.financialDiscount ?? 0;
                            final increment = payment.financialIncrement ?? 0;
                            final portions = payment.quantityOfPortions ?? 0;
                            final name =
                                payment.paymentFinalization?.Description;
                            return Container(
                              padding: const EdgeInsets.all(Sizes.p8),
                              decoration: BoxDecoration(
                                color: fIndex % 2 == 0
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(Sizes.p8),
                              ),
                              child: Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: name,
                                      style: context.theme.textTheme.titleSmall,
                                      children: [
                                        if (payment.value != null) ...[
                                          TextSpan(
                                            text: ' (R\$',
                                            style: context
                                                .theme
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: context
                                                      .theme
                                                      .primaryColor,
                                                  fontSize: 11,
                                                ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' ${payment.value.toString().toBrazilianNumber()})',
                                            style: context
                                                .theme
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: context
                                                      .theme
                                                      .primaryColor,
                                                ),
                                          ),
                                        ],
                                        if (portions > 1)
                                          TextSpan(
                                            text: ' em ${portions}x',
                                            style: context
                                                .theme
                                                .textTheme
                                                .titleSmall,
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (discount > 0)
                                    TitleAndSubTitle(
                                      title: context.l10n.discounts,
                                      subTitle: discount,
                                      subTitleIsPrice: true,
                                    ),
                                  if (increment > 0)
                                    TitleAndSubTitle(
                                      title: context.l10n.surcharges,
                                      subTitle: increment,
                                      subTitleIsPrice: true,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
