import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class ProductsPage extends ConsumerWidget {
  final TextEditingController searchProductController;
  final TextEditingController quantityController;
  final TextEditingController costController;
  final FocusNode quantityFocusNode;
  final FocusNode costFocusNode;
  final void Function(AsyncValue<PendingBuyRequestEntity>, ProductEntity)
  insertProduct;
  final GlobalKey<FormState> fieldsFormKey;
  final GlobalKey<FormState> quantityFormKey;
  final void Function(int, ProductEntity) onTapProduct;
  const ProductsPage({
    super.key,
    required this.searchProductController,
    required this.quantityController,
    required this.costController,
    required this.quantityFocusNode,
    required this.costFocusNode,
    required this.insertProduct,
    required this.fieldsFormKey,
    required this.quantityFormKey,
    required this.onTapProduct,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const searchProductKey = SearchProductKey(
      0,
      BsRoutine.buyRequest,
      Modules.buyRequest,
    );

    Future<void> searchProducts(
      AsyncValue<PendingBuyRequestEntity> pendingAsync,
    ) async {
      ref
          .read(uiStateControllerProvider.notifier)
          .updateSelectedProductIndex(null);
      await ref
          .read(
            searchProductsStateControllerProvider(searchProductKey).notifier,
          )
          .loadProducts(
            GetProductsJsonParams(
              enterpriseCodes:
                  pendingAsync.value?.selectedEnterprises
                      ?.map((e) => e.Code!)
                      .toList() ??
                  [],
              searchValue: searchProductController.text,
            ),
          );
    }

    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: DefaultSearchProducts(
                searchProductKey: searchProductKey,
                isLoading: ref.watch(
                  searchProductsStateControllerProvider(
                    searchProductKey,
                  ).select((state) => state.isLoading),
                ),
                searchProducts: () => searchProducts(pendingAsync),
                searchValueController: searchProductController,
              ),
            ),
            gapSliverH8,
            Consumer(
              builder: (_, ref, _) {
                final productsState = ref.watch(
                  searchProductsStateControllerProvider(searchProductKey),
                );

                return AsyncValueSliverWidget(
                  value: productsState,
                  tryAgain: null,
                  data: (products) {
                    final filteredProducts =
                        products
                            .where(
                              (e) =>
                                  pendingAsync.value?.selectedEnterprises
                                      ?.map((e) => e.Code)
                                      .contains(e.EnterpriseCode) ==
                                  true,
                            )
                            .toList()
                          ..sort((a, b) => a.Name!.compareTo(b.Name!));

                    return ProductsItems(
                      productsPage: this,
                      products: filteredProducts,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
