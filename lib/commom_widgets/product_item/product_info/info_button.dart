import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../core/domain/entities/entities.dart';
import '../../commom_widgets.dart';

class InfoButton extends StatelessWidget {
  final ProductItemWidget widget;
  const InfoButton(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    if (widget.routine == BsRoutine.goodsReceiving) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);

    return PrimaryTextButton(
      text: 'Info'.hardcoded,
      icon: Icon(
        theme.platform == TargetPlatform.iOS ? Icons.info : Icons.info,
        color: theme.primaryColor,
      ),
      onPressed: () {
        showModalPage(
          ProductInfoModal(product: widget.product, routine: widget.routine),
          context,
        );
      },
    );
  }
}
