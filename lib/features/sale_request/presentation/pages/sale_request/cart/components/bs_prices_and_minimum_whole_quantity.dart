import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../domain/entities/entities.dart';

class BsPricesAndMinimumWholeQuantity extends StatelessWidget {
  final CartProductEntity cartProduct;
  const BsPricesAndMinimumWholeQuantity({super.key, required this.cartProduct});

  @override
  Widget build(BuildContext context) {
    final retailPrice = cartProduct.product?.RetailPracticedPrice ?? 0;
    final minimumWholeQuantity = cartProduct.product?.MinimumWholeQuantity ?? 0;
    final wholePrice = cartProduct.product?.WholePracticedPrice ?? 0;

    return Padding(
      padding: const EdgeInsets.only(left: Sizes.p8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cartProduct.getValueLiquid != retailPrice)
            TitleAndSubTitle(
              title: 'Preço venda (BS)'.hardcoded,
              subTitle: retailPrice,
              subTitleIsPrice: true,
            ),
          if (minimumWholeQuantity > 0 && wholePrice > 0) ...[
            if (cartProduct.getValueLiquid != wholePrice)
              TitleAndSubTitle(
                title: 'Preço atacado (BS)'.hardcoded,
                subTitle: cartProduct.product!.WholePracticedPrice,
                subTitleIsPrice: true,
              ),
            TitleAndSubTitle(
              title: 'Qtd mín atacado'.hardcoded,
              subTitle: cartProduct.product!.MinimumWholeQuantity,
            ),
          ],
        ],
      ),
    );
  }
}
