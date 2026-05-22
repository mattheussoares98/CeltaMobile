import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/features/expedition_conference/domain/entities/entities.dart';

class ProductItem extends ConsumerWidget {
  final int expeditionControlCode;
  final bool isPending;
  final ExpeditionProductEntity product;
  const ProductItem({
    super.key,
    required this.expeditionControlCode,
    required this.isPending,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(top: Sizes.p8),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleAndSubTitle(title: null, subTitle: product.Name),
            TitleAndSubTitle(
              title: 'PLU'.hardcoded,
              subTitle: product.PriceLookUp,
            ),
            TitleAndSubTitle(
              title: 'Quantidade'.hardcoded,
              subTitle: product.Quantity.toString().toBrazilianNumber(),
            ),
          ],
        ),
      ),
    );
  }
}
