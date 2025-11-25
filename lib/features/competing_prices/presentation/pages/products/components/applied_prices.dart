import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../localization/string_hardcoded.dart';

class AppliedPrices extends StatelessWidget {
  final ProductEntity product;
  const AppliedPrices({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((product.RetailPracticedPrice ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Venda'.hardcoded,
            subTitle: product.RetailPracticedPrice,
            subTitleIsPrice: true,
          ),
        if ((product.RetailOfferPrice ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Venda (oferta)'.hardcoded,
            subTitle: product.RetailOfferPrice,
            subTitleIsPrice: true,
          ),
        if ((product.WholePracticedPrice ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Atacado'.hardcoded,
            subTitle: product.WholePracticedPrice,
            subTitleIsPrice: true,
          ),
        if ((product.WholeOfferPrice ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Atacado (oferta)'.hardcoded,
            subTitle: product.WholeOfferPrice,
            subTitleIsPrice: true,
          ),
        if ((product.ECommercePracticedPrice ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Ecommerce'.hardcoded,
            subTitle: product.ECommercePracticedPrice,
            subTitleIsPrice: true,
          ),
        if ((product.ECommerceOfferPrice ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Ecommerce (oferta)'.hardcoded,
            subTitle: product.ECommerceOfferPrice,
            subTitleIsPrice: true,
          ),
      ],
    );
  }
}
