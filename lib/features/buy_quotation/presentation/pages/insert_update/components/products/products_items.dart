import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../../enterprises/presentation/controllers/controllers.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controller.dart';
import '../components.dart';

class ProductsItems extends ConsumerWidget {
  final BuyQuotationEntity buyQuotation;
  final Map<String, TextEditingController> quantityControllers;
  final int enterpriseCode;
  final int code;
  const ProductsItems({
    super.key,
    required this.buyQuotation,
    required this.quantityControllers,
    required this.enterpriseCode,
    required this.code,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprises = ref.watch(enterprisesStateControllerProvider());

    final selectedIndex = ref.watch(
      selectedProductIndexStateControllerProvider,
    );

    void updateIndex(int? index) {
      final newIndex = (index == selectedIndex) ? null : index;

      ref
          .read(selectedProductIndexStateControllerProvider.notifier)
          .updateIndex(newIndex);

      if (newIndex != null) {
        final product = buyQuotation.Products?[newIndex];
        if (product == null) return;

        for (final entry in quantityControllers.entries) {
          final enterpriseCodeKey =
              entry.key; // String Code of the enterprise (e.g., '123')
          final controller = entry.value;

          if (buyQuotation.Enterprises?.any(
                (e) => e.enterprise.Code.toString() == enterpriseCodeKey,
              ) ==
              false) {
            controller.text = '0';
            continue;
          }

          final quantityEntity = product.ProductEnterprises?.firstWhereOrNull(
            (e) => e.EnterpriseCode.toString() == enterpriseCodeKey,
          );

          final quantity = quantityEntity?.Quantity;
          if (quantity != null) {
            controller.text = quantity
                .toString()
                .toBrazilianNumber()
                .replaceAll(RegExp(r'\.'), '');
          }
        }
      }
    }

    final canUpdateProductIndex =
        buyQuotation.Enterprises != null &&
        buyQuotation.Enterprises!.where((e) => e.isSelected == true).isNotEmpty;

    return SliverList.builder(
      itemCount: buyQuotation.Products?.length ?? 0,
      itemBuilder: (_, index) {
        final product = buyQuotation.Products![index];

        final productEnterprises =
            buyQuotation.Enterprises?.where((x) => x.isSelected == true).map((
              e,
            ) {
              final productEnterprise =
                  product.ProductEnterprises?.firstWhereOrNull(
                    (x) => x.EnterpriseCode == e.enterprise.Code,
                  );

              return productEnterprise ??
                  BuyQuotationProductEnterpriseEntity(
                    Code: productEnterprise?.Code,
                    EnterpriseCode: e.enterprise.Code,
                    Quantity: 0,
                  );
            }).toList();
        productEnterprises?.sort(
          (a, b) => a.EnterpriseCode?.compareTo(b.EnterpriseCode ?? 0) ?? 0,
        );

        final isSelected = index == selectedIndex;

        return ProductItemWidget(
          product: product.Product!,
          routine: BsRoutine.buyQuotation,
          showDropIcon: canUpdateProductIndex ? true : false,
          isSelected: isSelected,
          onTap: canUpdateProductIndex ? () => updateIndex(index) : null,
          itemBeforeProductName: QuantityByEnterprises(
            productEnterprises: productEnterprises,
            enterprises: enterprises.value,
          ),
          notClickableBottom: isSelected
              ? UpdateQuantities(
                  quantityControllers: quantityControllers,
                  buyQuotation: buyQuotation,
                  enterprises: enterprises.value!,
                  updateIndex: updateIndex,
                  product: product,
                  enterpriseCode: enterpriseCode,
                  code: code,
                )
              : null,
        );
      },
    );
  }
}
