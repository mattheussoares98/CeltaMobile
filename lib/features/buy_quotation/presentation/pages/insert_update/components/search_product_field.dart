import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../enterprises/presentation/controllers/controllers.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controller.dart';
import 'components.dart';

class SearchProductField extends ConsumerWidget {
  final int enterpriseCode;
  final TextEditingController searchValueController;
  final BuyQuotationEntity buyQuotation;
  const SearchProductField({
    super.key,
    required this.enterpriseCode,
    required this.searchValueController,
    required this.buyQuotation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.buyQuotation,
      Modules.buyQuotation,
    );

    final enterprises = ref.watch(enterprisesStateControllerProvider()).value;

    void addProducts(List<ProductEntity> products) async {
      final currentProducts = buyQuotation.Products ?? [];
      final updatedProducts = [
        ...products
            .where(
              (e) =>
                  currentProducts
                      .map((p) => p.Product?.ProductPackingCode)
                      .contains(e.ProductPackingCode) !=
                  true,
            )
            .map(
              (p) => BuyQuotationProductsEntity(
                Product: p,
                Code: p.ProductPackingCode,
                ProductEnterprises: enterprises!
                    .map(
                      (x) => BuyQuotationProductEnterpriseEntity(
                        Code: null,
                        EnterpriseCode: x.Code,
                        Quantity: 0,
                      ),
                    )
                    .toList(),
              ),
            ),
        ...currentProducts,
      ];
      final updated = ref
          .read(
            completeBuyQuotationsStateControllerProvider(
              enterpriseCode,
              buyQuotation.Code.toString(),
            ).notifier,
          )
          .updateValues(Products: updatedProducts);

      if (!updated) {
        await Future.delayed(Duration.zero);
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
      final value = await ref.watch(
        searchProductsStateControllerProvider(searchProductKey).future,
      );
      n.doOnSuccess(p, () async {
        if (value.length == 1) {
          addProducts([value.first]);
        } else if (value.length > 1) {
          await showModalPage(
            SelectProductsModal(
              enterpriseCode: enterpriseCode,
              searchProductKey: searchProductKey,
              addProducts: addProducts,
            ),
            context,
          );
        }
      });
      n.showSnackbarOnError(context, p);
    });

    final asyncValue = ref.watch(
      searchProductsStateControllerProvider(searchProductKey),
    );

    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produtos (${buyQuotation.Products?.length ?? 0})'.hardcoded,
            style: theme.textTheme.titleSmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.primaryColor,
            ),
          ),
          DefaultSearchProducts(
            isLoading: asyncValue.isLoading,
            searchProducts: () {
              ref
                  .read(
                    searchProductsStateControllerProvider(
                      searchProductKey,
                    ).notifier,
                  )
                  .loadProducts(
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
        ],
      ),
    );
  }
}
