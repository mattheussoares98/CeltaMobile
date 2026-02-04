import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../localization/string_hardcoded.dart';

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
          child: _DefaultSearchProduct(
            widget: this,
            searchType: SearchType.allProductsFromGoodsReceivingGoesForBalance,
            searchProduct: searchProduct,
          ),
        ),
        Expanded(
          flex: 30,
          child: _DefaultSearchProduct(
            widget: this,
            searchType: SearchType.allProductsFromGoodsReceiving,
            searchProduct: searchProduct,
          ),
        ),
        Expanded(
          flex: 30,
          child: _DefaultSearchProduct(
            widget: this,
            searchType: SearchType.allCountedProductsFromGoodsReceiving,
            searchProduct: searchProduct,
          ),
        ),
      ],
    );
  }
}

class _DefaultSearchProduct extends ConsumerWidget {
  final TopButtons widget;
  final SearchType searchType;
  final void Function(SearchType searchType) searchProduct;
  const _DefaultSearchProduct({
    required this.widget,
    required this.searchType,
    required this.searchProduct,
  });

  String get title {
    switch (searchType) {
      case SearchType.allProductsFromGoodsReceivingGoesForBalance:
        return 'Pesáveis'.hardcoded;
      case SearchType.allProductsFromGoodsReceiving:
        return 'Sem EAN'.hardcoded;
      case SearchType.allCountedProductsFromGoodsReceiving:
        return 'Já contados'.hardcoded;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLoading = ref.watch(
      searchProductsStateControllerProvider(
        widget.searchProductKey,
      ).select((s) => s.isLoading),
    );

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return PrimaryTextButton(
      text: title,
      isSmall: true,
      icon: Icon(isIOS ? CupertinoIcons.search : Icons.search),
      iconAlignment: IconAlignment.start,
      onPressed: isLoading ? null : () => searchProduct(searchType),
    );
  }
}
