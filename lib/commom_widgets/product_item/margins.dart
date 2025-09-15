import 'package:flutter/material.dart';

import 'product_item.dart';

class Margins extends StatelessWidget {
  const Margins({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(
          title: 'Varejo ',
          subTitle: widget.product.PriceCost.RetailMargin,
          subTitleIsPercentage: true,
        ),
        TitleAndSubTitle(
          title: 'Mín varejo ',
          subTitle: widget.product.PriceCost.RetailMinimumMargin,
          subTitleIsPercentage: true,
        ),
        TitleAndSubTitle(
          title: 'Mín varejo oferta ',
          subTitle: widget.product.PriceCost.RetailOfferMargin,
          subTitleIsPercentage: true,
        ),
        TitleAndSubTitle(
          title: 'Atacado ',
          subTitle: widget.product.PriceCost.WholeMargin,
          subTitleIsPercentage: true,
        ),
        TitleAndSubTitle(
          title: 'Mín atacado ',
          subTitle: widget.product.PriceCost.WholeMinimumMargin,
          subTitleIsPercentage: true,
        ),
        TitleAndSubTitle(
          title: 'Oferta atacado ',
          subTitle: widget.product.PriceCost.WholeOfferMargin,
          subTitleIsPercentage: true,
        ),
        TitleAndSubTitle(
          title: 'Ecommerce ',
          subTitle: widget.product.PriceCost.ECommerceMargin,
          subTitleIsPercentage: true,
        ),
        TitleAndSubTitle(
          title: 'Mín ecommerce ',
          subTitle: widget.product.PriceCost.ECommerceMinimumMargin,
          subTitleIsPercentage: true,
        ),
        TitleAndSubTitle(
          title: 'Mín ecommerce oferta ',
          subTitle: widget.product.PriceCost.ECommerceOfferMargin,
          subTitleIsPercentage: true,
        ),
      ],
    );
  }
}
