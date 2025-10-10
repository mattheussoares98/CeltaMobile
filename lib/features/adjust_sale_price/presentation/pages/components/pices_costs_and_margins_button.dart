import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';

class PricesCostsAndMarginsButton extends StatelessWidget {
  final ProductEntity product;
  final int enterpriseCode;
  const PricesCostsAndMarginsButton({
    super.key,
    required this.product,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PrimaryTextButton(
      isLoading: false,
      text: 'Preços, custos e margens'.hardcoded,
      onPressed: () {
        showModalPage(
          ProductInfoModal(
            product: product,
            enterpriseCode: enterpriseCode,
            routine: BsRoutine.adjustSalePrice,
          ),
          context,
        );
      },
      icon: Icon(
        theme.platform == TargetPlatform.iOS ? CupertinoIcons.info : Icons.info,
      ),
    );
  }
}
