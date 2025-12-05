import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class InsertProductsPage extends ConsumerStatefulWidget {
  final DraftKey draftKey;
  final bool requestTypeAllowChangePrice;
  const InsertProductsPage({
    super.key,
    required this.draftKey,
    required this.requestTypeAllowChangePrice,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InsertProductsPageState();
}

class _InsertProductsPageState extends ConsumerState<InsertProductsPage> {
  final searchValueController = TextEditingController();
  final searchValueFocusNode = FocusNode();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  int? selectedIndex;

  @override
  void dispose() {
    super.dispose();
    searchValueController.dispose();
    searchValueFocusNode.dispose();
    quantityController.dispose();
    priceController.dispose();
    quantityFocusNode.dispose();
    priceFocusNode.dispose();
  }

  void onTapProductItem({
    required int index,
    required ProductEntity product,
    required List<RequestTypeEntity>? requests,
    required TransferRequestProductItemEntity? transferRequestProductItem,
  }) {
    priceController.clear();

    if (product.Value == 0 && !widget.requestTypeAllowChangePrice) {
      showSnackBarMessage(
        context,
        'O produto está com o preço zerado e o modelo de pedido selecionado não permite alterar o preço'
            .hardcoded,
        backgroundColor: Colors.red,
      );
      setState(() {
        selectedIndex = null;
      });
      return;
    }

    if (selectedIndex == index) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() => selectedIndex = index);
      quantityController.text = '1';

      if (product.Value! > 0 || transferRequestProductItem?.value != null) {
        final price = transferRequestProductItem?.value ?? product.Value;
        priceController.text = price.toString().replaceAll(RegExp(r'\.'), ',');
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        quantityFocusNode.requestFocus();
      });
    }
  }

  void removeProductItem(
    TransferRequestProductItemEntity productItem,
    DraftKey draftKey,
  ) {
    ref
        .read(cartProductsStateControllerProvider(draftKey).notifier)
        .removeItem(productItem);
  }

  @override
  Widget build(BuildContext context) {
    final searchProductKey = SearchProductKey(
      widget.draftKey.enterpriseOrigin,
      BsRoutine.transferRequest,
      Modules.transferRequest,
      anotherKey:
          '${widget.draftKey.enterpriseOrigin}-${widget.draftKey.enterpriseDestinyCode}-${widget.draftKey.requestTypeCode}',
    );
    ref.listen(searchProductsStateControllerProvider(searchProductKey), (p, n) {
      n.doOnSuccess(p, () {
        searchValueController.clear();
      });
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: Column(
        children: [
          DefaultSearchProducts(
            isLoading: ref.watch(
              searchProductsStateControllerProvider(
                searchProductKey,
              ).select((value) => value.isLoading),
            ),
            focusNode: searchValueFocusNode,
            searchProducts: () {
              ref
                  .read(
                    searchProductsStateControllerProvider(
                      searchProductKey,
                    ).notifier,
                  )
                  .loadProducts(
                    GetProductsByRequestTypeParams(
                      searchValue: searchValueController.text,
                      enterpriseOriginCode: widget.draftKey.enterpriseOrigin,
                      enterpriseDestinyCode:
                          widget.draftKey.enterpriseDestinyCode,
                      requestTypeCode: widget.draftKey.requestTypeCode,
                    ),
                  );
            },
            searchValueController: searchValueController,
          ),
          gapH8,
          Expanded(
            child: CustomScrollView(
              slivers: [
                Consumer(
                  builder: (_, ref, _) {
                    return AsyncValueSliverWidget(
                      value: ref.watch(
                        searchProductsStateControllerProvider(searchProductKey),
                      ),
                      tryAgain: null,
                      data: (products) {
                        return ProductsItems(
                          products: products,
                          selectedIndex: selectedIndex,
                          onTap: onTapProductItem,
                          removeItem: (item) =>
                              removeProductItem(item, widget.draftKey),
                          requestTypeAllowChangePrice:
                              widget.requestTypeAllowChangePrice,
                          draftKey: widget.draftKey,
                          quantityController: quantityController,
                          priceController: priceController,
                          quantityFocusNode: quantityFocusNode,
                          priceFocusNode: priceFocusNode,
                          changeSelectedIndex: (index) => setState(() {
                            selectedIndex = index;
                          }),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
