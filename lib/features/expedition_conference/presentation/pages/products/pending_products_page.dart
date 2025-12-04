import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class PendingProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  final FocusNode focusNode;
  final TextEditingController searchValueController;
  final int expeditionControlCode;
  const PendingProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.focusNode,
    required this.searchValueController,
    required this.expeditionControlCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingProductsAsync = ref.watch(
      expeditionConferenceControllerProvider(expeditionControlCode),
    );
    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.generic,
      Modules.expeditionConference,
    );

    void searchProducts() {
      ref
          .read(
            searchProductsStateControllerProvider(searchProductKey).notifier,
          )
          .loadProducts(
            GetProductsJsonParams(
              searchValue: searchValueController.text,
              enterpriseCodes: [enterpriseCode],
            ),
          );
    }

    if (pendingProductsAsync.value?.pendingProducts == null ||
        pendingProductsAsync.value!.pendingProducts.isEmpty) {
      return EmptyProductsMessage(
        onRefreshEmptyProducts: () {
          ref.invalidate(
            expeditionConferenceControllerProvider(expeditionControlCode),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: Sizes.p4),
              child: DefaultSearchProducts(
                isLoading:
                    ref.watch(
                      expeditionConferenceControllerProvider(
                        expeditionControlCode,
                      ).select((state) => state.isLoading),
                    ) ||
                    ref.watch(
                      searchProductsStateControllerProvider(
                        searchProductKey,
                      ).select((state) => state.isLoading),
                    ),
                focusNode: focusNode,
                searchProducts: searchProducts,
                searchValueController: searchValueController,
              ),
            ),
          ),
          PendingProductsItems(expeditionControlCode: expeditionControlCode),
        ],
      ),
    );
  }
}
