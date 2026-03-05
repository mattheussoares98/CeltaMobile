import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/products/products.dart';
import './components/components.dart';

class SearchProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const SearchProductsPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchProductsPageState();
}

class _SearchProductsPageState extends ConsumerState<SearchProductsPage> {
  final searchValueController = TextEditingController();

  @override
  void dispose() {
    searchValueController.dispose();
    super.dispose();
  }

  Future<void> searchProducts(SearchProductKey searchProductKey) async {
    await ref
        .read(searchProductsStateControllerProvider(searchProductKey).notifier)
        .loadProducts(
          GetProductsJsonParams(
            searchValue: searchValueController.text,
            enterpriseCodes: [widget.enterpriseCode],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final searchProductKey = SearchProductKey(
      widget.enterpriseCode,
      BsRoutine.priceConference,
      Modules.searchProducts,
    );

    return Scaffold(
      appBar: AppBar(
        title: DefaultAppBarTitle(title: 'Pesquisar produtos'.hardcoded),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: Column(
          children: [
            Consumer(
              builder: (_, ref, _) {
                return DefaultSearchProducts(
                  searchValueController: searchValueController,
                  searchProductKey: searchProductKey,
                  isLoading: ref.watch(
                    searchProductsStateControllerProvider(
                      searchProductKey,
                    ).select((state) => state.isLoading),
                  ),
                  searchProducts: () => searchProducts(searchProductKey),
                );
              },
            ),
            gapH8,
            Expanded(
              child: Consumer(
                builder: (_, ref, _) {
                  return AsyncValueWidget(
                    value: ref.watch(
                      searchProductsStateControllerProvider(searchProductKey),
                    ),
                    tryAgain: null,
                    data: (products) {
                      return ResponsiveListFlow(
                        itemCount: products.length,
                        itemBuilder: (_, index) {
                          final product = products[index];
                          return ProductItem(
                            key: ValueKey(product.ProductPackingCode),
                            product: product,
                            enterpriseCode: widget.enterpriseCode,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
