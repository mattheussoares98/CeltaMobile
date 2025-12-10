import 'package:flutter/material.dart';

import '../../../core/domain/entities/entities.dart';
import '../../../localization/string_hardcoded.dart';
import '../../commom_widgets.dart';

class PracticedPriceProperty extends StatelessWidget {
  final ProductItemWidget widget;
  const PracticedPriceProperty(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    if ([
      BsRoutine.adjustStock,
      BsRoutine.buyRequest,
      BsRoutine.goodsReceiving,
      BsRoutine.researchOfPrice,
    ].contains(widget.routine)) {
      return const SizedBox.shrink();
    }
    return TitleAndSubTitle(
      title: "Preço ",
      emptyMessage: 'Sem preço'.hardcoded,
      subTitle: widget.routine == BsRoutine.transferRequest
          ? widget.product.Value
          : ((widget.product.Value ?? 0) > 0
                ? widget.product.Value
                : widget.product.RetailPracticedPrice),
      subTitleIsPrice: true,
    );
  }
}
