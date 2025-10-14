import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class PendingProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  final EnterpriseEntity? selectedEnterprise;
  final FocusNode focusNode;
  final TextEditingController searchValueController;
  final AsyncValue<ExpeditionConferenceState> pendingProductsAsync;
  final AsyncValue<List<ProductEntity>> searchProductsAsync;
  final int expeditionControlCode;
  const PendingProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.selectedEnterprise,
    required this.focusNode,
    required this.searchValueController,
    required this.pendingProductsAsync,
    required this.searchProductsAsync,
    required this.expeditionControlCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void searchProducts() {
      ref
          .read(
            searchProductsStateControllerProvider(
              enterpriseCode,
              BsRoutine.generic,
              selectedEnterprise?.name ?? '',
            ).notifier,
          )
          .loadProducts(
            searchValue: searchValueController.text,
            enterpriseCode: enterpriseCode,
            selectedEnterprise: selectedEnterprise,
          );
    }

    if (pendingProductsAsync.value?.pendingProducts == null ||
        pendingProductsAsync.value!.pendingProducts.isEmpty) {
      return EmptyProductsMessage(
        onRefreshEmptyProducts: () {
          ref.invalidate(
            expeditionConferenceControllerProvider(
              expeditionControlCode,
              selectedEnterprise?.name ?? '',
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: DefaultSearchProducts(
              isLoading:
                  pendingProductsAsync.isLoading ||
                  searchProductsAsync.isLoading,
              focusNode: focusNode,
              searchProducts: searchProducts,
              searchValueController: searchValueController,
            ),
          ),
          PendingProductsItems(
            products: pendingProductsAsync.value!.pendingProducts,
          ),
        ],
      ),
    );
  }
}
