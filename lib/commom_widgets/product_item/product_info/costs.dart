import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../commom_widgets.dart';

class Costs extends StatelessWidget {
  const Costs({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScrollableWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTitle(title: 'Custos'.hardcoded),
          gapH8,
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
      ),
    );
  }
}
