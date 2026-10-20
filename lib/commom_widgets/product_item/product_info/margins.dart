import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
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
          BaseText.headline(context.l10n.margins, textAlign: TextAlign.center),
          gapH8,
          TitleAndSubTitle(
            title: context.l10n.retailPrefix,
            subTitle: (widget.product.PriceCost?.RetailMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.minimumRetailPrefix,
            subTitle: (widget.product.PriceCost?.RetailMinimumMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.minimumRetailOfferPrefix,
            subTitle: (widget.product.PriceCost?.RetailOfferMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.wholesale,
            subTitle: (widget.product.PriceCost?.WholeMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.minimumWholesalePrefix,
            subTitle: (widget.product.PriceCost?.WholeMinimumMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.wholesaleOfferPrefix,
            subTitle: (widget.product.PriceCost?.WholeOfferMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.eCommerce,
            subTitle: (widget.product.PriceCost?.ECommerceMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.minimumEcommercePrefix,
            subTitle: (widget.product.PriceCost?.ECommerceMinimumMargin ?? 0),
            subTitleIsPercentage: true,
          ),
          TitleAndSubTitle(
            title: context.l10n.minimumEcommerceOfferPrefix,
            subTitle: (widget.product.PriceCost?.ECommerceOfferMargin ?? 0),
            subTitleIsPercentage: true,
          ),
        ],
      ),
    );
  }
}
