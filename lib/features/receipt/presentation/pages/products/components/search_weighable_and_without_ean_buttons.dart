import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../localization/string_hardcoded.dart';

class SearchWeighableAndWithoutEanButtons extends StatelessWidget {
  final void Function(SearchType searchType) searchProduct;
  const SearchWeighableAndWithoutEanButtons({
    super.key,
    required this.searchProduct,
  });

  @override
  Widget build(BuildContext context) {
    final themne = Theme.of(context);
    final isIOS = themne.platform == TargetPlatform.iOS;

    return Row(
      children: [
        Expanded(
          child: PrimaryTextButton(
            text: 'Pesáveis'.hardcoded,
            icon: Icon(isIOS ? CupertinoIcons.search : Icons.search),
            iconAlignment: IconAlignment.start,
            onPressed: () => searchProduct(
              SearchType.allProductsFromGoodsReceivingGoesForBalance,
            ),
          ),
        ),
        Expanded(
          child: PrimaryTextButton(
            text: 'Sem EAN'.hardcoded,
            icon: Icon(isIOS ? CupertinoIcons.search : Icons.search),
            iconAlignment: IconAlignment.start,
            onPressed: () =>
                searchProduct(SearchType.allProductsFromGoodsReceiving),
          ),
        ),
      ],
    );
  }
}
