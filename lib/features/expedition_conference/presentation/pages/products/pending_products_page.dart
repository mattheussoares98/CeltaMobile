import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
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
  final int expeditionControlCode;
  final String documentNumber;
  final int enterpriseCode;
  final EnterpriseEntity? selectedEnterprise;
  final FocusNode focusNode;
  final TextEditingController searchValueController;
  final AsyncValue<List<ExpeditionProductEntity>?> pendingProductsAsync;
  const PendingProductsPage({
    super.key,
    required this.expeditionControlCode,
    required this.documentNumber,
    required this.enterpriseCode,
    required this.selectedEnterprise,
    required this.focusNode,
    required this.searchValueController,
    required this.pendingProductsAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProductsAsync = ref.watch(
      searchProductsStateControllerProvider(
        enterpriseCode,
        BsRoutine.goodsReceiving, //TODO change to module
        selectedEnterprise?.name ?? '',
      ),
    );

    ref.listen(
      searchProductsStateControllerProvider(
        enterpriseCode,
        BsRoutine.goodsReceiving, //TODO change to module
        selectedEnterprise?.name ?? '',
      ),
      (p, n) {
        n.showSnackbarOnError(
          context,
          previous: p,
          message: 'Houve um problema para pesquisar o produto. Tente novamente'
              .hardcoded,
        );

        n.doOnSuccess(p, () {
          if (searchProductsAsync.value != null &&
              searchProductsAsync.value!.length == 1) {
            //TODO add in confered product
            debugPrint('TODO add in confered product');
            Future.delayed(Duration(milliseconds: 100), () {
              focusNode.requestFocus();
            });
          } else {
            //TODO show modal page to select the correct product to count
            debugPrint(
              'show modal page to select the correct product to count',
            );
          }
          searchValueController.clear();
        });
      },
    );

    void onRefresh() {
      ref.invalidate(
        expeditionConferenceControllerProvider(
          expeditionControlCode,
          selectedEnterprise?.name ?? '',
        ),
      );
    }

    void searchProducts() {
      ref
          .read(
            searchProductsStateControllerProvider(
              selectedEnterprise!.Code!,
              BsRoutine.goodsReceiving,
              selectedEnterprise!.name,
            ).notifier,
          )
          .loadProducts(
            searchValue: searchValueController.text,
            enterpriseCode: selectedEnterprise!.Code!,
            selectedEnterprise: selectedEnterprise,
          );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Pendentes ($documentNumber)'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: AsyncValueWidget(
          value: pendingProductsAsync,
          tryAgain: onRefresh,
          data: (products) {
            if (products == null || products.isEmpty) {
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
                PendingProductsItems(products: products),
              ],
            );
          },
        ),
      ),
    );
  }
}
