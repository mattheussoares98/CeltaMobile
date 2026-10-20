import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';

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
            title: context.l10n.retailPrice,
            subTitle: product.RetailPracticedPrice,
            subTitleIsPrice: true,
          ),
        if ((product.RetailOfferPrice ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.retailOfferPrice,
            subTitle: product.RetailOfferPrice,
            subTitleIsPrice: true,
          ),
        if ((product.WholePracticedPrice ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.corePracticedPriceTypeWhole,
            subTitle: product.WholePracticedPrice,
            subTitleIsPrice: true,
          ),
        if ((product.WholeOfferPrice ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.wholesaleOfferPrice,
            subTitle: product.WholeOfferPrice,
            subTitleIsPrice: true,
          ),
        if ((product.ECommercePracticedPrice ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.ecommercePrice,
            subTitle: product.ECommercePracticedPrice,
            subTitleIsPrice: true,
          ),
        if ((product.ECommerceOfferPrice ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.ecommerceOfferPrice,
            subTitle: product.ECommerceOfferPrice,
            subTitleIsPrice: true,
          ),
      ],
    );
  }
}
