import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomersWithErrorsItems extends StatelessWidget {
  const CustomersWithErrorsItems({super.key, required this.items});
  final List<EcCustomerWithErrorSynchronizerErrorDetailEntity> items;

  @override
  Widget build(BuildContext context) {
    return ResponsiveListFlow(
      padding: const EdgeInsets.all(Sizes.p8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final bleeding = items[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                TitleAndSubTitle(
                  title: context.l10n.enterprise,
                  subTitle: bleeding.enterprisePersonalizedCode,
                ),
                TitleAndSubTitle(
                  title: context.l10n.customerName,
                  subTitle: bleeding.customerName,
                ),
                TitleAndSubTitle(
                  title: context.l10n.errorDate,
                  subTitle: bleeding.creationDate.formatDate(.ddMMyyyyHHmm),
                ),
                TitleAndSubTitle(
                  title: context.l10n.registrationDate,
                  subTitle: bleeding.cadasterDate.formatDate(.ddMMyyyyHHmm),
                ),
                TitleAndSubTitle(
                  title: context.l10n.customerCode,
                  subTitle: bleeding.customerCode,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
