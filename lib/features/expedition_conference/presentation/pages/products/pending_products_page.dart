import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../domain/entities/entities.dart';
import 'components/components.dart';

class PendingProductsPage extends ConsumerWidget {
  final int expeditionControlCode;
  final String documentNumber;
  final int enterpriseCode;
  final EnterpriseEntity? selectedEnterprise;
  final FocusNode focusNode;
  final TextEditingController searchValueController;
  final AsyncValue<ExpeditionConferenceState> pendingProductsAsync;
  final VoidCallback onRefresh;
  final AsyncValue<List<ProductEntity>> searchProductsAsync;
  const PendingProductsPage({
    super.key,
    required this.expeditionControlCode,
    required this.documentNumber,
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

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text('Pendentes ($documentNumber)'.hardcoded)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: AsyncValueWidget(
          value: pendingProductsAsync,
          tryAgain: onRefresh,
          data: (conferenceState) {
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
      ),
    );
  }
}
