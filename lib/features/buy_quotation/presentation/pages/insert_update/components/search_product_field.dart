import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/buy_quotation/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/controllers/controller.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/pages/insert_update/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchProductField extends ConsumerWidget {
  final int enterpriseCode;
  final int code;
  final TextEditingController searchValueController;
  const SearchProductField({
    super.key,
    required this.enterpriseCode,
    required this.code,
    required this.searchValueController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.buyQuotation,
      Modules.buyQuotation,
    );

    final enterprises = ref.watch(enterprisesStateControllerProvider()).value;
    final completeBuyQuotationProvider =
        completeBuyQuotationsStateControllerProvider(
          enterpriseCode,
          code.toString(),
        );
    final searchProductProvider = searchProductsStateControllerProvider(
      searchProductKey,
    );

    final currentProducts =
        ref.watch(
          completeBuyQuotationProvider.select((s) => s.value?.Products),
        ) ??
        [];

    void addProducts(List<ProductEntity> newProducts) async {
      // 1. Create a Set of incoming IDs for O(1) lookup.
      final incomingIds = newProducts.map((p) => p.ProductPackingCode).toSet();

      // 2. Separate current products into those that will be "moved" and those that stay.
      final existentToMove = <BuyQuotationProductsEntity>[];
      final remainingProducts = <BuyQuotationProductsEntity>[];

      for (final item in currentProducts) {
        if (incomingIds.contains(item.Product?.ProductPackingCode)) {
          existentToMove.add(item);
        } else {
          remainingProducts.add(item);
        }
      }

      // 3. Identify truly new products (those not already in the current list).
      final existingInCurrentIds = currentProducts
          .map((e) => e.Product?.ProductPackingCode)
          .toSet();

      final trulyNewItems = newProducts
          .where((p) => !existingInCurrentIds.contains(p.ProductPackingCode))
          .map(
            (p) => BuyQuotationProductsEntity(
              Product: p,
              Code: null,
              // Pre-mapping enterprises once instead of inside a nested where.
              ProductEnterprises: enterprises!.map((x) {
                return BuyQuotationProductEnterpriseEntity(
                  Code: null,
                  EnterpriseCode: x.Code,
                  Quantity: 0,
                );
              }).toList(),
            ),
          )
          .toList();

      // 4. Combine: New items first, then moved existing items, then the rest.
      final updatedProducts = [
        ...trulyNewItems,
        ...existentToMove,
        ...remainingProducts,
      ];

      final updated = ref
          .read(completeBuyQuotationProvider.notifier)
          .updateValues(Products: updatedProducts);

      if (!updated) {
        await Future.delayed(Duration.zero);
        if (!context.mounted) return;
        showAlertDialog(
          context: context,
          title: 'Erro'.hardcoded,
          content:
              'Não foi possível adicionar os produtos. Entre em contato com o suporte'
                  .hardcoded,
        );
      }
    }

    ref.listen(searchProductsStateControllerProvider(searchProductKey), (
      p,
      n,
    ) async {
      n.doOnSuccess(p, () async {
        if (n.value?.length == 1) {
          addProducts([n.value!.first]);
        } else if (n.value!.length > 1) {
          await showModalPage(
            SelectProductsModal(
              enterpriseCode: enterpriseCode,
              searchProductKey: searchProductKey,
              addProducts: addProducts,
              buyQuotationCode: code,
            ),
            context,
          );
        }
      });
      n.showToastOnError(context, p);
    });

    return SliverToBoxAdapter(
      child: BaseSearchProducts(
        searchProducts: (exactProductCode) {
          ref
              .read(searchProductProvider.notifier)
              .loadProducts(
                exactProductCode: exactProductCode,
                GetProductsJsonParams(
                  searchValue: searchValueController.text,
                  enterpriseCodes: [enterpriseCode],
                ),
              );
        },
        searchValueController: searchValueController,
        searchProductKey: SearchProductKey(
          enterpriseCode,
          BsRoutine.buyQuotation,
          Modules.buyQuotation,
        ),
      ),
    );
  }
}
