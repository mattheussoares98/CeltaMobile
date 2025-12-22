import 'package:flutter/material.dart';

import '../../../core/domain/entities/entities.dart';
import '../../commom_widgets.dart';

class WholePriceAndMinQuantity extends StatelessWidget {
  final ProductItemWidget widget;
  const WholePriceAndMinQuantity(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    if ([
      BsRoutine.adjustSalePrice,
      BsRoutine.adjustStock,
      BsRoutine.buyQuotation,
      BsRoutine.researchOfPrice,
      BsRoutine.priceConference,
      BsRoutine.saleRequest,
    ].contains(widget.routine)) {
      return const SizedBox.shrink();
    } else if ((widget.product.WholePracticedPrice ?? 0) == 0) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(
          title: 'Preço atacado',
          subTitle: widget.product.WholePracticedPrice,
          subTitleIsPrice: true,
        ),
        TitleAndSubTitle(
          title: 'Qtd mín p/ atacado',
          subTitle: widget.product.MinimumWholeQuantity,
        ),
      ],
    );
  }
}
