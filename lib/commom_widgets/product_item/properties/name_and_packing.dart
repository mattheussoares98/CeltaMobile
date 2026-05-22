import 'package:flutter/material.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';

class NameAndPacking extends StatelessWidget {
  final ProductEntity product;
  const NameAndPacking({super.key, required this.product});

  String get subtitle {
    if (product.PackingQuantity == null &&
        product.PackingAbbreviation == null) {
      return '';
    }

    if (product.PackingQuantity?.toDouble() != null) {
      if (product.PackingAbbreviation == null) {
        return " (${product.PackingQuantity?.toString().toBrazilianNumber(3, true)})";
      }
      return "(${product.PackingAbbreviation} ${product.PackingQuantity?.toString().toBrazilianNumber(3, true)})";
    }

    return " (${product.PackingQuantity.toString().formattedPacking()})";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TitleAndSubTitle(
      copyableTitle: true,
      title: product.Name,
      removeColon: true,
      subTitle: subtitle,
      titleStyle: theme.textTheme.titleMedium,
      subTitleStyle: theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.secondary,
      ),
    );
  }
}
