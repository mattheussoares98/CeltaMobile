import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import 'product_item.dart';

class Prices extends StatelessWidget {
  const Prices({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TitleAndSubTitle(
          title: 'Venda '.hardcoded,
          subTitle: widget.product.RetailPracticedPrice,
          subTitleIsPrice: true,
        ),
        TitleAndSubTitle(
          title: 'Atacado '.hardcoded,
          subTitle: widget.product.WholePracticedPrice,
          subTitleIsPrice: true,
        ),
        TitleAndSubTitle(
          title: 'Ecommerce '.hardcoded,
          subTitle: widget.product.ECommercePracticedPrice,
          subTitleIsPrice: true,
        ),
      ],
    );
  }
}
