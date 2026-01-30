import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final searchProductController = TextEditingController();
  static const searchProductKey = SearchProductKey(
    0,
    BsRoutine.buyRequest,
    Modules.buyRequest,
  );

  @override
  dispose() {
    super.dispose();
    searchProductController.dispose();
  }

  Future<void> searchProducts() async {
    ref
        .read(uiStateControllerProvider.notifier)
        .updateSelectedProductIndex(null);
    final selectedEnterprises = ref.read(
      pendingBuyRequestStateControllerProvider.select(
        (s) => s.value?.selectedEnterprises,
      ),
    );
    await ref
        .read(searchProductsStateControllerProvider(searchProductKey).notifier)
        .loadProducts(
          GetProductsJsonParams(
            enterpriseCodes:
                selectedEnterprises?.map((e) => e.Code!).toList() ?? [],
            searchValue: searchProductController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: CustomScrollView(
          slivers: [
            Consumer(
              builder: (_, ref, _) {
                return SliverToBoxAdapter(
                  child: DefaultSearchProducts(
                    searchProductKey: searchProductKey,
                    isLoading: ref.watch(
                      searchProductsStateControllerProvider(
                        searchProductKey,
                      ).select((state) => state.isLoading),
                    ),
                    searchProducts: searchProducts,
                    searchValueController: searchProductController,
                  ),
                );
              },
            ),
            gapSliverH8,
            const ProductsItems(),
            gapSliverH48,
          ],
        ),
      ),
    );
  }
}
