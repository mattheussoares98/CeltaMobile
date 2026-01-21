import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../controllers/controller.dart';
import '../../../../models/models.dart';
import '../../../pages.dart';
import '../components.dart';

class ProductsItems extends ConsumerWidget {
  final List<EnterpriseUIController> uiControllers;
  final InsertUpdatePage widget;
  final FocusNode observationsFocusNode;
  final TextEditingController filterProductsController;
  const ProductsItems({
    super.key,
    required this.uiControllers,
    required this.widget,
    required this.observationsFocusNode,
    required this.filterProductsController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buyQuotationEnterprises = ref.watch(
      completeBuyQuotationsStateControllerProvider(
        widget.enterpriseCode,
        widget.code.toString(),
      ).select(
        (s) => s.value?.Enterprises
            ?.where((x) => x.isSelected == true)
            .sortedBy((e) => e.enterprise.Code.toString()),
      ),
    );

    void updateSelectedPackingCode(int? productPackingCode) {
      if (observationsFocusNode.hasFocus) {
        observationsFocusNode.unfocus();
      }

      ref
          .read(selectedProductPackingCodeStateControllerProvider.notifier)
          .updateProductPackingCode(productPackingCode);

      if (productPackingCode == null) {
        return;
      }

      final products = ref
          .read(
            completeBuyQuotationsStateControllerProvider(
              widget.enterpriseCode,
              widget.code.toString(),
            ),
          )
          .value
          ?.Products;

      final product = products?.firstWhereOrNull(
        (p) => p.Product?.ProductPackingCode == productPackingCode,
      );
      if (product == null) return;

      for (final uiController in uiControllers) {
        final controller = uiController.controller;

        if (buyQuotationEnterprises?.any(
              (e) => e.enterprise.Code == uiController.enterpriseCode,
            ) ==
            false) {
          controller.text = '0';
          continue;
        }

        final quantity = product.ProductEnterprises?.firstWhereOrNull(
          (e) => e.EnterpriseCode == uiController.enterpriseCode,
        )?.Quantity;

        if (quantity != null && quantity > 0) {
          controller.text = quantity
              .toString()
              .toBrazilianNumber(3)
              .replaceAll(RegExp(r'\.'), '');
        } else {
          controller.clear();
        }
      }
    }

    return AnimatedBuilder(
      animation: filterProductsController,
      builder: (_, _) {
        final filteredProducts = ref
            .read(
              completeBuyQuotationsStateControllerProvider(
                widget.enterpriseCode,
                widget.code.toString(),
              ).notifier,
            )
            .filterProducts(filterProductsController.text);
        final productsCount = filteredProducts.length;

        return ResponsiveListFlow(
          isSliver: true,
          itemCount: productsCount,
          itemBuilder: (_, index) {
            final product = filteredProducts[index];
            return ProductItem(
              onTap: () => updateSelectedPackingCode(
                product.Product?.ProductPackingCode,
              ),
              product: product,
              filteredProducts: filteredProducts,
              sortedEnterprises: buyQuotationEnterprises,
              parentWidget: widget,
              uiControllers: uiControllers,
              enterpriseCode: widget.enterpriseCode,
              buyQuotationCode: widget.code,
            );
          },
        );
      },
    );
  }
}
