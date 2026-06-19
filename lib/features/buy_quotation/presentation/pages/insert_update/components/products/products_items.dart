import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/controllers/controller.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/models/models.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/pages/insert_update/components/components.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/pages/pages.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    void updateSelectedPackingCode(int? productPackingCode) async {
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

      final sortedUIControllers = uiControllers.sorted(
        (a, b) => a.enterprisePersonalizedCode.compareTo(
          b.enterprisePersonalizedCode,
        ),
      );

      for (var x = 0; x < sortedUIControllers.length; x++) {
        final uiController = sortedUIControllers[x];
        final focusNode = uiController.focusNode;
        final controller = uiController.controller;

        if (x == 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (focusNode.hasFocus) {
              focusNode.unfocus();
            }
            Future.delayed(const Duration(milliseconds: 300), () {
              focusNode.requestFocus();
              controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.text.length,
              );
            });
          });
        }

        if (buyQuotationEnterprises?.any(
              (e) => e.enterprise.Code == uiController.enterpriseCode,
            ) ==
            false) {
          controller.text = '0';
          continue;
        }

        final quantity =
            product.ProductEnterprises?.firstWhereOrNull(
              (e) => e.EnterpriseCode == uiController.enterpriseCode,
            )?.Quantity ??
            0;

        if (quantity > 0) {
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
              key: ValueKey(product.Product?.ProductPackingCode),
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
