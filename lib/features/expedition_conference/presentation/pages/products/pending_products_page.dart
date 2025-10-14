import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../domain/entities/entities.dart';
import 'components/components.dart';

class PendingProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  final EnterpriseEntity? selectedEnterprise;
  final FocusNode focusNode;
  final TextEditingController searchValueController;
  final AsyncValue<ExpeditionConferenceState> pendingProductsAsync;
  final VoidCallback onRefresh;
  final AsyncValue<List<ProductEntity>> searchProductsAsync;
  const PendingProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.selectedEnterprise,
    required this.focusNode,
    required this.searchValueController,
    required this.pendingProductsAsync,
    required this.onRefresh,
    required this.searchProductsAsync,
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

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: AsyncValueWidget(
        value: pendingProductsAsync,
        tryAgain: onRefresh,
        data: (conferenceState) {
          if (conferenceState.pendingProducts.isEmpty &&
              conferenceState.scannedProducts.isNotEmpty) {
            return Center(
              child: PrimaryTextButton(
                text: 'Should try to confirm the conference',
                onPressed: () {
                  //TODO implement
                },
              ),
            );
          }

          if (conferenceState.pendingProducts.isEmpty) {
            return EmptyProductsMessage(onRefresh: onRefresh);
          }

          return CustomScrollView(
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
              PendingProductsItems(products: conferenceState.pendingProducts),
            ],
          );
        },
      ),
    );
  }
}
