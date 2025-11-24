import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../core/domain/entities/entities.dart';
import '../commom_widgets.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({super.key, required this.product, required this.routine});
  final ProductEntity product;
  final BsRoutine routine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PrimaryTextButton(
      text: 'Info'.hardcoded,
      icon: Icon(
        theme.platform == TargetPlatform.iOS ? Icons.info : Icons.info,
        color: theme.primaryColor,
        // size: 16,
      ),
      onPressed: () {
        showModalPage(
          ProductInfoModal(product: product, routine: routine),
          context,
        );
      },
    );
  }
}
