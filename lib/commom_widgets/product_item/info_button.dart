import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
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
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        showModalPage(
          ProductInfoModal(
            product: product,
            enterpriseCode: enterpriseCode,
            routine: routine,
          ),
          context,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
        child: Row(
          children: [
            Text(
              'Info'.hardcoded,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.primaryColor,
              ),
            ),
            gapW8,
            if (mediaQuery.size.width >= 200)
              Icon(
                theme.platform == TargetPlatform.iOS ? Icons.info : Icons.info,
                color: theme.primaryColor,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
