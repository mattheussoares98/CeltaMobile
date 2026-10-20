import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';

class ReplacementCostProperty extends StatelessWidget {
  final ProductItemWidget widget;
  const ReplacementCostProperty(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool hasPermission = widget.product.ReplacementCost != -1;

    return TitleAndSubTitle(
      title: hasPermission ? context.l10n.replacementCostPrefix : null,
      subTitle: hasPermission ? widget.product.ReplacementCost : null,
      emptyMessage: hasPermission ? context.l10n.noReplacementCost : null,
      subTitleIsPrice: true,
    );
  }
}
