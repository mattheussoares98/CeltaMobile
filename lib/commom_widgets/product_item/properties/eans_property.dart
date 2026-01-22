import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../core/domain/entities/entities.dart';
import '../../../localization/string_hardcoded.dart';
import '../../commom_widgets.dart';

class EansProperty extends StatelessWidget {
  final ProductItemWidget widget;
  const EansProperty(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    bool hasEan =
        widget.product.EANs != null &&
        widget.product.EANs!.isNotEmpty &&
        widget.product.EANs!.any((e) => e.isNotEmpty);

    return Padding(
      padding: EdgeInsets.only(
        top: widget.routine == BsRoutine.buyQuotation ? Sizes.p16 : 0,
      ),
      child: TitleAndSubTitle(
        title: hasEan ? 'EANs'.hardcoded : null,
        subTitle: widget.product.EANs?.map((e) => e.toString()).join(', '),
      ),
    );
  }
}
