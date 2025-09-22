import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../commom_widgets.dart';

class Prices extends StatelessWidget {
  const Prices({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context) {
    final retailSuggestion =
        widget.product.PriceCost.RetailSuggestionPrice ?? 0;
    final wholeSuggestion = widget.product.PriceCost.WholeSuggestionPrice ?? 0;
    final ecommerceSuggestion =
        widget.product.PriceCost.ECommerceSuggestionPrice ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Title(title: 'Preços praticados'),
        gapH8,
        TitleAndSubTitle(
          title: 'Venda '.hardcoded,
          subTitle: widget
              .product
              .RetailPracticedPrice, //TODO add information when is offer price and add a button to finish the offer when the user has permission
          subTitleIsPrice: true,
        ),
        TitleAndSubTitle(
          title: 'Atacado '.hardcoded,
          subTitle: widget
              .product
              .WholePracticedPrice, //TODO add information when is offer price and add a button to finish the offer when the user has permission
          subTitleIsPrice: true,
        ),
        TitleAndSubTitle(
          title: 'Ecommerce '.hardcoded,
          subTitle: widget.product.ECommercePracticedPrice,
          subTitleIsPrice: true,
        ),
        if (retailSuggestion > 0 ||
            wholeSuggestion > 0 ||
            ecommerceSuggestion > 0) ...[
          gapH32,

          _Title(title: 'Preços sugeridos'),
          gapH8,
          if (retailSuggestion > 0)
            TitleAndSubTitle(
              title: 'Venda '.hardcoded,
              subTitle: retailSuggestion,
              subTitleIsPrice: true,
            ),
          if (wholeSuggestion > 0)
            TitleAndSubTitle(
              title: 'Atacado '.hardcoded,
              subTitle: wholeSuggestion,
              subTitleIsPrice: true,
            ),
          if (ecommerceSuggestion > 0)
            TitleAndSubTitle(
              title: 'Ecommerce '.hardcoded,
              subTitle: ecommerceSuggestion,
              subTitleIsPrice: true,
            ),
        ],
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  const _Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title.hardcoded,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
