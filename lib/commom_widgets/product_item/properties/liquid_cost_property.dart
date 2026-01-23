import 'package:flutter/material.dart';

import '../../../localization/string_hardcoded.dart';
import '../../commom_widgets.dart';

class LiquidCostProperty extends StatelessWidget {
  final ProductItemWidget widget;
  const LiquidCostProperty(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool hasPermission = widget.product.LiquidCost != -1;

    return TitleAndSubTitle(
      title: hasPermission ? "Custo líquido " : null,
      subTitle: hasPermission ? widget.product.LiquidCost : null,
      emptyMessage: hasPermission ? 'Sem custo líquido'.hardcoded : null,
      subTitleIsPrice: true,
    );
  }
}
