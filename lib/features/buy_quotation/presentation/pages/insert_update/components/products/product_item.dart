import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_quotation/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/controllers/controller.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/models/models.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/pages/insert_update/components/components.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/pages/pages.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductItem extends ConsumerWidget {
  final BuyQuotationProductsEntity product;
  final VoidCallback onTap;
  final List<EnterpriseUIController> uiControllers;
  final int enterpriseCode;
  final int buyQuotationCode;
  final List<BuyQuotationEnterpriseEntity>? sortedEnterprises;
  final InsertUpdatePage parentWidget;
  final List<BuyQuotationProductsEntity> filteredProducts;
  const ProductItem({
    super.key,
    required this.product,
    required this.onTap,
    required this.uiControllers,
    required this.enterpriseCode,
    required this.buyQuotationCode,
    required this.sortedEnterprises,
    required this.parentWidget,
    required this.filteredProducts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Granular selector. This specific row only rebuilds
    // if its own product data changes.

    final isSelected = ref.watch(
      selectedProductPackingCodeStateControllerProvider.select(
        (s) => s == product.Product!.ProductPackingCode,
      ),
    );

    final productEnterprises = sortedEnterprises?.map((e) {
      final pe = product.ProductEnterprises?.firstWhereOrNull(
        (x) => x.EnterpriseCode == e.enterprise.Code,
      );
      return pe ??
          BuyQuotationProductEnterpriseEntity(
            Code: null,
            EnterpriseCode: e.enterprise.Code,
            Quantity: 0,
          );
    }).toList();

    return RepaintBoundary(
      child: ProductItemWidget(
        product: product.Product!,
        routine: BsRoutine.buyQuotation,
        showEditIcon: true,
        isSelected: isSelected,
        onTap: onTap,
        onDelete: () {
          final completeBuyQuotationProvider =
              completeBuyQuotationsStateControllerProvider(
                enterpriseCode,
                buyQuotationCode.toString(),
              );

          final currentProducts = ref.read(
            completeBuyQuotationProvider.select((s) => s.value!.Products),
          );

          currentProducts!.removeWhere(
            (e) =>
                e.Product!.ProductPackingCode ==
                product.Product!.ProductPackingCode,
          );

          ref
              .read(completeBuyQuotationProvider.notifier)
              .updateValues(Products: currentProducts);
          //TODO fix it, is not working
        },
        itemBeforeProductName: QuantityByEnterprises(
          productEnterprises: productEnterprises,
        ),
        notClickableBottom: isSelected
            ? UpdateQuantities(
                uiControllers: uiControllers,
                product: product,
                enterpriseCode: enterpriseCode,
                buyQuotationCode: buyQuotationCode,
              )
            : null,
      ),
    );
  }
}
