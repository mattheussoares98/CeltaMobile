import 'package:flutter/material.dart';

import '../../../localization/string_hardcoded.dart';
import '../../commom_widgets.dart';

class EansProperty extends StatelessWidget {
  final ProductItemWidget widget;
  const EansProperty(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    if (widget.product.EANs != null &&
        widget.product.EANs!.isNotEmpty &&
        widget.product.EANs!.any((e) => e.isNotEmpty)) {
      return TitleAndSubTitle(
        title: 'EANs'.hardcoded,
        subTitle: widget.product.EANs!.map((e) => e.toString()).join(', '),
      );
    }
    return const SizedBox.shrink();
  }
}
