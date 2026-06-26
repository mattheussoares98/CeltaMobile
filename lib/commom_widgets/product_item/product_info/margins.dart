import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class Margins extends StatelessWidget {
  const Margins({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScrollableWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultText.headline(
            'Margens'.hardcoded,
            textAlign: TextAlign.center,
          ),
          gapH8,
          TitleAndSubTitle(
            title: 'Varejo ',
            subTitle: (widget.product.PriceCost?.RetailMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: 'Mín varejo ',
            subTitle: (widget.product.PriceCost?.RetailMinimumMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: 'Mín varejo oferta ',
            subTitle: (widget.product.PriceCost?.RetailOfferMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: 'Atacado ',
            subTitle: (widget.product.PriceCost?.WholeMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: 'Mín atacado ',
            subTitle: (widget.product.PriceCost?.WholeMinimumMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: 'Oferta atacado ',
            subTitle: (widget.product.PriceCost?.WholeOfferMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: 'Ecommerce ',
            subTitle: (widget.product.PriceCost?.ECommerceMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: 'Mín ecommerce ',
            subTitle: (widget.product.PriceCost?.ECommerceMinimumMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: 'Mín ecommerce oferta ',
            subTitle: (widget.product.PriceCost?.ECommerceOfferMargin ?? 0),
            subTitleIsPercentage: true,
          ),
        ],
      ),
    );
  }
}
