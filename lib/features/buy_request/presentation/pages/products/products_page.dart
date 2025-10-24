import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../enterprise_manager/domain/entities/entities.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final TextEditingController searchProductController;
  final TextEditingController quantityController;
  final TextEditingController costController;
  final FocusNode quantityFocusNode;
  final FocusNode costFocusNode;
  final void Function(AsyncValue<PendingBuyRequestEntity>, ProductEntity)
  insertProduct;
  final int? selectedIndex;
  final void Function(int? index) changeSelectedIndex;
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
    required this.selectedIndex,
    required this.changeSelectedIndex,
    required this.fieldsFormKey,
    required this.quantityFormKey,
    required this.onTapProduct,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  Future<void> searchProducts(
    AsyncValue<PendingBuyRequestEntity> pendingAsync,
  ) async {
    await ref
        .read(
          searchProductsStateControllerProvider(
            0,
            BsRoutine.buyRequest,
            Modules.buyRequest,
          ).notifier,
        )
        .loadProducts(
          enterpriseCodes:
              pendingAsync.value?.selectedEnterprises
                  ?.map((e) => e.Code!)
                  .toList() ??
              [],
          searchValue: widget.searchProductController.text,
        );
  }

  //TODO changeto stateless

  @override
  Widget build(BuildContext context) {
    ref.listen(
      searchProductsStateControllerProvider(
        0,
        BsRoutine.buyRequest,
        Modules.buyRequest,
      ),
      (products, next) {
        next.doOnSuccess(products, () {
          widget.searchProductController.clear();
        });
      },
    );

    final productsState = ref.watch(
      searchProductsStateControllerProvider(
        0,
        BsRoutine.buyRequest,
        Modules.buyRequest,
      ),
    );

    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: DefaultSearchProducts(
                isLoading: productsState.isLoading,
                searchProducts: () => searchProducts(pendingAsync),
                searchValueController: widget.searchProductController,
              ),
            ),
            gapSliverH8,
            AsyncValueSliverWidget(
              value: productsState,
              tryAgain: null,
              data: (products) {
                final filteredProducts = products
                    .where(
                      (e) =>
                          pendingAsync.value?.selectedEnterprises
                              ?.map((e) => e.Code)
                              .contains(e.EnterpriseCode) ==
                          true,
                    )
                    .toList();

                return ProductsItems(
                  productsPage: widget,
                  products: filteredProducts,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
