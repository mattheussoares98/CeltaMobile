import 'package:flutter/material.dart';

import '../../../localization/string_hardcoded.dart';
import '../../commom_widgets.dart';

class EansProperty extends StatelessWidget {
  final ProductItemWidget widget;
  const EansProperty(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: TitleAndSubTitle(
        title: 'EANs'.hardcoded,
        subTitle: widget.product.EANs?.map((e) => e.toString()).join(', '),
      ),
    );
  }
}
