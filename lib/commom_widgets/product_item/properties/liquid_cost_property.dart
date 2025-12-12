import 'package:flutter/material.dart';

import '../../../core/domain/entities/entities.dart';
import '../../../localization/string_hardcoded.dart';
import '../../commom_widgets.dart';

class LiquidCostProperty extends StatelessWidget {
  final ProductItemWidget widget;
  const LiquidCostProperty(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    if ([
      BsRoutine.adjustStock,
      BsRoutine.buyQuotation,
      BsRoutine.goodsReceiving,
      BsRoutine.transferRequest,
    ].contains(widget.routine)) {
      return const SizedBox.shrink();
    }

    return TitleAndSubTitle(
      title: "Custo líquido ",
      subTitle: widget.product.LiquidCost,
      emptyMessage: 'Sem custo líquido'.hardcoded,
      subTitleIsPrice: true,
    );
  }
}
