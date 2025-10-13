import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';

class PendingProductsItems extends StatelessWidget {
  final List<ExpeditionProductEntity> products;
  const PendingProductsItems({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];
        return Card(
          margin: EdgeInsets.only(top: Sizes.p8),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleAndSubTitle(title: null, subTitle: product.Name),
                TitleAndSubTitle(
                  title: 'PLU'.hardcoded,
                  subTitle: product.PriceLookUp,
                ),
                TitleAndSubTitle(
                  title: 'Quantidade'.hardcoded,
                  subTitle: product.Quantity.toString().toBrazilianNumber(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
