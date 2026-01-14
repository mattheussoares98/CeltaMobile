import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../routing/routing.dart';

class TopButtons extends ConsumerWidget {
  final int enterpriseCode;
  final int receiptCode;
  final SearchProductKey searchProductKey;
  const TopButtons({
    super.key,
    required this.enterpriseCode,
    required this.receiptCode,
    required this.searchProductKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themne = Theme.of(context);
    final isIOS = themne.platform == TargetPlatform.iOS;

    void searchProduct(SearchType searchType) async {
      ref
          .read(
            searchProductsStateControllerProvider(searchProductKey).notifier,
          )
          .loadProducts(
            GetProductsReceiptParams(searchValue: '%', grDocCode: receiptCode),
            specifiedSearchType: searchType,
          );
    }

    return Row(
      children: [
        Expanded(
          flex: 30,
          child: PrimaryTextButton(
            text: 'Pesáveis'.hardcoded,
            isSmall: true,
            icon: Icon(isIOS ? CupertinoIcons.search : Icons.search),
            iconAlignment: IconAlignment.start,
            onPressed: () => searchProduct(
              SearchType.allProductsFromGoodsReceivingGoesForBalance,
            ),
          ),
        ),
        Expanded(
          flex: 30,
          child: PrimaryTextButton(
            text: 'Sem EAN'.hardcoded,
            isSmall: true,
            icon: Icon(isIOS ? CupertinoIcons.search : Icons.search),
            iconAlignment: IconAlignment.start,
            onPressed: () =>
                searchProduct(SearchType.allProductsFromGoodsReceiving),
          ),
        ),
        Expanded(
          flex: 40,
          child: PrimaryTextButton(
            text: 'Não encontrados'.hardcoded,
            isSmall: true,
            icon: Icon(isIOS ? CupertinoIcons.add : Icons.add),
            iconAlignment: IconAlignment.start,
            onPressed: () {
              context.goNamed(
                Routes.receiptProductsNotFound.name,
                pathParameters: {
                  'enterpriseCode': enterpriseCode.toString(),
                  'receiptCode': receiptCode.toString(),
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
