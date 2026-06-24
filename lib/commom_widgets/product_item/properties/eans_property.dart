import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class EansProperty extends StatelessWidget {
  final ProductItemWidget widget;
  const EansProperty(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: TitleAndSubTitle(
        copyableSubtitle: true,
        title: 'EANs'.hardcoded,
        subTitle: widget.product.EANs?.map((e) => e.toString()).join(', '),
      ),
    );
  }
}
