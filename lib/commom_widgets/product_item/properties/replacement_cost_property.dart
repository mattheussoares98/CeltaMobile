import 'package:flutter/material.dart';

import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';

class ReplacementCostProperty extends StatelessWidget {
  final ProductItemWidget widget;
  const ReplacementCostProperty(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool hasPermission = widget.product.ReplacementCost != -1;

    return TitleAndSubTitle(
      title: hasPermission ? "Custo de reposição " : null,
      subTitle: hasPermission ? widget.product.ReplacementCost : null,
      emptyMessage: hasPermission ? 'Sem custo de reposição'.hardcoded : null,
      subTitleIsPrice: true,
    );
  }
}
