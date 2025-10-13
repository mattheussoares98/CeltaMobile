import 'package:celta_intelligence/core/presentation/controllers/products/products.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class ProductsConferencePage extends ConsumerStatefulWidget {
  final int expeditionControlCode;
  final int stepCode;
  final EnterpriseEntity? selectedEnterprise;
  final String documentNumber;
  final int enterpriseCode;
  const ProductsConferencePage({
    super.key,
    required this.expeditionControlCode,
    required this.stepCode,
    required this.selectedEnterprise,
    required this.documentNumber,
    required this.enterpriseCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductsConferencePageState();
}

class _ProductsConferencePageState
    extends ConsumerState<ProductsConferencePage> {
  final searchValueController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
    focusNode.dispose();
  }

  void searchProducts() {
    ref
        .read(
          searchProductsStateControllerProvider(
            widget.selectedEnterprise!.Code!,
            BsRoutine.goodsReceiving,
            widget.selectedEnterprise!.name,
          ).notifier,
        )
        .loadProducts(
          searchValue: searchValueController.text,
          enterpriseCode: widget.selectedEnterprise!.Code!,
          selectedEnterprise: widget.selectedEnterprise,
        );
  }

  void onRefresh() {
    ref.invalidate(
      pendingProductsStateControllerProvider(
        widget.expeditionControlCode,
        widget.selectedEnterprise?.name ?? '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingProductsAsync = ref.watch(
      pendingProductsStateControllerProvider(
        widget.expeditionControlCode,
        widget.selectedEnterprise?.name ?? '',
      ),
    );

    final searchProductsAsync = ref.watch(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.goodsReceiving, //TODO change to module
        widget.selectedEnterprise!.name,
      ),
    );

    ref.listen(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.goodsReceiving, //TODO change to module
        widget.selectedEnterprise!.name,
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Pendentes (${widget.documentNumber})'.hardcoded),
      ),
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
