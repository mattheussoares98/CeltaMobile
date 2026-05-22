import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/controllers/controller.dart';
import 'package:celta_inventario/utils/utils.dart';

class SelectProductsModal extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final SearchProductKey searchProductKey;
  final void Function(List<ProductEntity> products) addProducts;
  final int buyQuotationCode;
  const SelectProductsModal({
    super.key,
    required this.enterpriseCode,
    required this.searchProductKey,
    required this.addProducts,
    required this.buyQuotationCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectProductsModalState();
}

class _SelectProductsModalState extends ConsumerState<SelectProductsModal> {
  final ValueNotifier<Map<String, ProductEntity>> selectedProductsNotifier =
      ValueNotifier({});

  @override
  void dispose() {
    selectedProductsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('select_products_${widget.enterpriseCode}_buy_quotation'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(Sizes.p8, 0, Sizes.p8, Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Consumer(
                builder: (_, ref, _) {
                  final asyncValue = ref.watch(
                    searchProductsStateControllerProvider(
                      widget.searchProductKey,
                    ),
                  );

                  final products = asyncValue.value ?? [];

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (_, index) {
                      final product = products[index];
                      final productPacking =
                          product.ProductPackingCode.toString();

                      return _ProductItem(
                        key: ValueKey('product_${product.ProductPackingCode}'),
                        buyQuotationCode: widget.buyQuotationCode,
                        enterpriseCode: widget.enterpriseCode,
                        product: product,
                        productPacking: productPacking,
                        selectedProductsNotifier: selectedProductsNotifier,
                      );
                    },
                  );
                },
              ),
            ),
            PrimaryButton(
              text: 'Adicionar',
              onPressed: () {
                widget.addProducts(
                  selectedProductsNotifier.value.values.toList(),
                );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductItem extends ConsumerWidget {
  const _ProductItem({
    super.key,
    required this.product,
    required this.productPacking,
    required this.buyQuotationCode,
    required this.enterpriseCode,
    required this.selectedProductsNotifier,
  });

  final ProductEntity product;
  final String productPacking;
  final int buyQuotationCode;
  final int enterpriseCode;
  final ValueNotifier<Map<String, ProductEntity>> selectedProductsNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alreadyInBuyQuotation = ref.watch(
      completeBuyQuotationsStateControllerProvider(
        enterpriseCode,
        buyQuotationCode.toString(),
      ).select(
        (s) =>
            s.value?.Products?.any(
              (e) => e.Product?.ProductPackingCode.toString() == productPacking,
            ) ??
            false,
      ),
    );

    final theme = Theme.of(context);
    final isIOS = PlatformUtil.isCupertino;

    void toggleSelection() {
      final currentMap = Map<String, ProductEntity>.from(
        selectedProductsNotifier.value,
      );
      if (currentMap.containsKey(productPacking)) {
        currentMap.remove(productPacking);
      } else {
        currentMap[productPacking] = product;
      }
      selectedProductsNotifier.value = currentMap;
    }

    return RepaintBoundary(
      child: GestureDetector(
        //is not using ProductItemWidget property because behave differently in iOS
        onTap: isIOS ? toggleSelection : null,
        child: ProductItemWidget(
          product: product,
          routine: BsRoutine.buyQuotation,
          showInfoButton: false,
          onTap: isIOS ? null : toggleSelection,
          clickableBottom: alreadyInBuyQuotation
              ? Text(
                  'Esse produto já foi inserido!'.hardcoded,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                )
              : null,
          rightWidget: ValueListenableBuilder<Map<String, ProductEntity>>(
            valueListenable: selectedProductsNotifier,
            builder: (context, selectedMap, _) {
              return Checkbox(
                value: selectedMap.containsKey(productPacking),
                onChanged: (_) => toggleSelection(),
              );
            },
          ),
        ),
      ),
    );
  }
}
