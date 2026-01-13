import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final searchProductController = TextEditingController();
  @override
  dispose() {
    super.dispose();
    searchProductController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
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
            const ProductsItems(),
          ],
        ),
      ),
    );
  }
}
