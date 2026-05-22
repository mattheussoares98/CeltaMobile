import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';

class Financial extends ConsumerWidget {
  const Financial({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financials = ref.watch(
      saleRequestDetailsStateControllerProvider(
        ref.read(saleRequestArgsProvider),
      ).select((s) => s.value?.financials),
    );

    final payments = financials?.firstOrNull?.paymentFinalizations;
    final bool isFinancialEmpty = payments?.isEmpty ?? true;

    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                        ? 'Sem financeiro'.hardcoded
                        : 'Financeiro'.hardcoded,
                    style: theme.textTheme.bodyLarge?.copyWith(
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: payments!.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];

                  final discount = payment.financialDiscount ?? 0;
                  final increment = payment.financialIncrement ?? 0;
                  final portions = payment.quantityOfPortions ?? 0;
                  final name = payment.paymentFinalization?.Description;
                  return Container(
                    margin: const EdgeInsets.only(bottom: Sizes.p4),
                    padding: const EdgeInsets.all(Sizes.p8),
                    decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? Colors.grey.shade300
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(Sizes.p8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: name,
                            style: theme.textTheme.titleSmall,
                            children: [
                              if (payment.value != null) ...[
                                TextSpan(
                                  text: ' (R\$',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                    fontSize: 11,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' ${payment.value.toString().toBrazilianNumber()})',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ],
                              if (portions > 1)
                                TextSpan(
                                  text: ' em ${portions}x',
                                  style: theme.textTheme.titleSmall,
                                ),
                            ],
                          ),
                        ),
                        if (discount > 0)
                          TitleAndSubTitle(
                            title: 'Descontos'.hardcoded,
                            subTitle: discount,
                            subTitleIsPrice: true,
                          ),
                        if (increment > 0)
                          TitleAndSubTitle(
                            title: 'Acréscimos'.hardcoded,
                            subTitle: increment,
                            subTitleIsPrice: true,
                          ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
