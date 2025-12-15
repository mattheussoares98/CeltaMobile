import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
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

    void addProducts(List<ProductEntity> products) {
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
      ref
          .read(
            completeBuyQuotationsStateControllerProvider(
              enterpriseCode,
              buyQuotation.Code.toString(),
            ).notifier,
          )
          .updateValues(
            Products: updatedProducts,
          ); //TODO cant allow repeat product
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

    return SliverToBoxAdapter(
      child: DefaultSearchProducts(
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
    );
  }
}
