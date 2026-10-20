import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';

class PracticedPriceProperty extends StatelessWidget {
  final ProductItemWidget widget;
  const PracticedPriceProperty(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    return TitleAndSubTitle(
      title: context.l10n.pricePrefix,
      emptyMessage: context.l10n.noPrice,
      subTitle: widget.routine == BsRoutine.transferRequest
          ? widget.product.Value
          : ((widget.product.Value ?? 0) > 0
                ? widget.product.Value
                : widget.product.RetailPracticedPrice),
      subTitleIsPrice: true,
    );
  }
}
