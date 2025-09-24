import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../commom_widgets.dart';

class Margins extends StatelessWidget {
  const Margins({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScrollableWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTitle(title: 'Margens'.hardcoded),
          gapH8,
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
      ),
    );
  }
}
