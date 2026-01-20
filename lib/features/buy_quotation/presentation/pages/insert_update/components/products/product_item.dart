import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controller.dart';
import '../../../../models/models.dart';
import '../../../pages.dart';
import '../components.dart';

class ProductItem extends ConsumerWidget {
  final int index;
  final VoidCallback onTap;
  final List<EnterpriseUIController> uiControllers;
  final int enterpriseCode;
  final int buyQuotationCode;
  final List<BuyQuotationEnterpriseEntity>? sortedEnterprises;
  final InsertUpdatePage parentWidget;
  const ProductItem({
    super.key,
    required this.index,
    required this.onTap,
    required this.uiControllers,
    required this.enterpriseCode,
    required this.buyQuotationCode,
    required this.sortedEnterprises,
    required this.parentWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Granular selector. This specific row only rebuilds
    // if its own product data changes.
    final product = ref.watch(
      completeBuyQuotationsStateControllerProvider(
        enterpriseCode,
        buyQuotationCode.toString(),
      ).select((s) => s.value?.Products?[index]),
    );

    if (product == null) return const SizedBox.shrink();

    // Watch selection status separately.
    final isSelected = ref.watch(
      selectedProductIndexStateControllerProvider.select((s) => s == index),
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
        showDropIcon: true,
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
        },
        itemBeforeProductName: QuantityByEnterprises(
          productEnterprises: productEnterprises,
        ),
        clickableBottom: SizedBox(
          height:
              product.Product!.EANs != null &&
                  product.Product!.EANs!.length <= 1
              ? Sizes.p20
              : 0,
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
