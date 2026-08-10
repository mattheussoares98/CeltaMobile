import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
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
                  title: 'Empresa'.hardcoded,
                  subTitle: bleeding.enterprisePersonalizedCode,
                ),
                TitleAndSubTitle(
                  title: 'Nome cliente'.hardcoded,
                  subTitle: bleeding.customerName,
                ),
                TitleAndSubTitle(
                  title: 'Data erro'.hardcoded,
                  subTitle: bleeding.creationDate.formatDate(.ddMMyyyyHHmm),
                ),
                TitleAndSubTitle(
                  title: 'Data cadastro'.hardcoded,
                  subTitle: bleeding.cadasterDate.formatDate(.ddMMyyyyHHmm),
                ),
                TitleAndSubTitle(
                  title: 'Cód cliente'.hardcoded,
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
