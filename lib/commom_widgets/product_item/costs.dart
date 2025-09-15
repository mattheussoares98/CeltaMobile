import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import 'product_item.dart';

class Costs extends StatelessWidget {
  //TODO test these values
  const Costs({super.key, required this.widget});

  final ProductInfo widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(
          title: 'Líquido '.hardcoded,
          subTitle: widget.product.LiquidCost,
          subTitleIsPrice: true,
        ),
        TitleAndSubTitle(
          title: 'Líquido médio '.hardcoded,
          subTitle: widget.product.LiquidCostMidle,
          subTitleIsPrice: true,
        ),
        TitleAndSubTitle(
          title: 'Fiscal '.hardcoded,
          subTitle: widget.product.FiscalCost,
          subTitleIsPrice: true,
        ),
        TitleAndSubTitle(
          title: 'Fiscal líquido '.hardcoded,
          subTitle: widget.product.FiscalLiquidCost,
          subTitleIsPrice: true,
        ),
        TitleAndSubTitle(
          title: 'Operacional '.hardcoded,
          subTitle: widget.product.OperationalCost,
          subTitleIsPrice: true,
        ),
        TitleAndSubTitle(
          title: 'Real '.hardcoded,
          subTitle: widget.product.RealCost,
          subTitleIsPrice: true,
        ),
        TitleAndSubTitle(
          title: 'Real líquido '.hardcoded,
          subTitle: widget.product.RealLiquidCost,
          subTitleIsPrice: true,
        ),
        TitleAndSubTitle(
          title: 'Reposição '.hardcoded,
          subTitle: widget.product.ReplacementCost,
          subTitleIsPrice: true,
        ),
        TitleAndSubTitle(
          title: 'Reposição médio '.hardcoded,
          subTitle: widget.product.ReplacementCostMidle,
          subTitleIsPrice: true,
        ),
      ],
    );
  }
}
