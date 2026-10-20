import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/bs_version/bs_version.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      if (searchType == SearchType.allCountedProductsFromGR) {
        final bsDate = await ref.read(bsVersionStateControllerProvider.future);

        if (bsDate?.isBefore(DateTime(2026, 02)) ?? false) {
          if (!context.mounted) return;
          showAlertDialog(
            context: context,
            title: context.l10n.updateRequired,
            content: context.l10n.askBsSupportToUpdateTheSystemToUseThis,
          );
          return;
        }
      }
      ref
          .read(
            searchProductsStateControllerProvider(searchProductKey).notifier,
          )
          .loadProducts(
            exactProductCode: null,
            GetProductsReceiptParams(searchValue: '%', grDocCode: receiptCode),
            specifiedSearchType: searchType,
          );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 30,
          child: _DefaultSearchProduct(
            widget: this,
            searchType: SearchType.allProductsFromGRGoesForBalance,
            searchProduct: searchProduct,
          ),
        ),
        Flexible(
          flex: 30,
          child: _DefaultSearchProduct(
            widget: this,
            searchType: SearchType.allProductsFromGR,
            searchProduct: searchProduct,
          ),
        ),
        Flexible(
          flex: 37,
          child: OptimazedAsyncValueWidget(
            provider: bsVersionStateControllerProvider,
            tryAgain: () => ref.invalidate(bsVersionStateControllerProvider),
            child: _DefaultSearchProduct(
              widget: this,
              searchType: SearchType.allCountedProductsFromGR,
              searchProduct: searchProduct,
            ),
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

  String title(BuildContext context) {
    switch (searchType) {
      case SearchType.allProductsFromGRGoesForBalance:
        return context.l10n.weighedProducts;
      case SearchType.allProductsFromGR:
        return context.l10n.noEan;
      case SearchType.allCountedProductsFromGR:
        return context.l10n.alreadyCounted;
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

    return FittedBox(
      child: PrimaryTextButton(
        text: title(context),
        isSmall: true,
        platformIcon: const PlatformIcon(
          cupertinoIcon: CupertinoIcons.search,
          materialIcon: Icons.search,
        ),
        iconAlignment: IconAlignment.start,
        onPressed: isLoading ? null : () => searchProduct(searchType),
      ),
    );
  }
}
