import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../core/domain/entities/entities.dart';
import '../commom_widgets.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({
    super.key,
    required this.product,
    required this.enterpriseCode,
    required this.routine,
  });
  final int enterpriseCode;
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
          ProductInfoModal(
            product: product,
            enterpriseCode: enterpriseCode,
            routine: routine,
          ),
          context,
        );
      },
    );
  }
}
