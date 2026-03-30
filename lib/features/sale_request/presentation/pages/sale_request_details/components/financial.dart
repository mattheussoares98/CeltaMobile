import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../controllers/controllers.dart';

class Financial extends ConsumerWidget {
  final int saleRequestId;
  final int customerCode;
  final int enterpriseCode;
  const Financial({
    super.key,
    required this.saleRequestId,
    required this.customerCode,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financials = ref.watch(
      saleRequestDetailsStateControllerProvider(
        customerCode: customerCode,
        enterpriseCode: enterpriseCode,
        saleRequestCode: saleRequestId,
      ).select((s) => s.value?.financials),
    );

    if (financials?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: financials!.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  isIOS ? CupertinoIcons.creditcard : Icons.credit_card,
                ),
              );
            }

            final financial = financials[index - 1];
            final payments = financial.paymentFinalizations;

            if (payments?.isEmpty ?? true) {
              return const SizedBox.shrink();
            }

            return ListView.builder(
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
                          style: theme.textTheme.titleMedium,
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
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ],
                            if (portions > 1)
                              TextSpan(
                                text: ' em ${portions}x',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
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
            );
          },
        ),
      ),
    );
  }
}
