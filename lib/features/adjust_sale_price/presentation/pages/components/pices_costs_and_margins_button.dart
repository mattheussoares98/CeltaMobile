import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';

class PricesCostsAndMarginsButton extends StatelessWidget {
  final ProductEntity product;
  const PricesCostsAndMarginsButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return PrimaryTextButton(
      isLoading: false,
      text: 'Preços, custos e margens'.hardcoded,
      onPressed: () {
        showModalPage(ProductInfoModal(product: product), context);
      },
      icon: Icon(
        defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoIcons.info
            : Icons.info,
      ),
    );
  }
}
