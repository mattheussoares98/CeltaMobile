import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';

class ProductItem extends StatelessWidget {
  final ExpeditionProductEntity product;
  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: Sizes.p8),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
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
  }
}
