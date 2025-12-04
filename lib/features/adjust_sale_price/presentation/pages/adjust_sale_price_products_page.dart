import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/products/products.dart';
import '../../../../routing/routing.dart';

class AdjustSalePriceProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const AdjustSalePriceProductsPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdjustSalePriceProductsPageState();
}

class _AdjustSalePriceProductsPageState
    extends ConsumerState<AdjustSalePriceProductsPage> {
  final searchValueController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    searchValueController.dispose();
  }

  Future<void> _searchProducts() async {
    await ref
        .read(
          searchProductsStateControllerProvider(
            SearchProductKey(
              widget.enterpriseCode,
              BsRoutine.adjustSalePrice,
              Modules.adjustPrice,
            ),
          ).notifier,
        )
        .loadProducts(
          GetProductsJsonParams(
            searchValue: searchValueController.text,
            enterpriseCodes: [widget.enterpriseCode],
            routine: BsRoutine.adjustSalePrice,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final searchProductKey = SearchProductKey(
      widget.enterpriseCode,
      BsRoutine.adjustSalePrice,
      Modules.adjustPrice,
    );

    ref.listen(searchProductsStateControllerProvider(searchProductKey), (
      previous,
      next,
    ) {
      next.doOnSuccess(previous, () {
        searchValueController.clear();
      });
    });

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text("Produtos (ajuste de preço)".hardcoded)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p4),
        child: Column(
          children: [
            DefaultSearchProducts(
              searchValueController: searchValueController,
              isLoading: ref.watch(
                searchProductsStateControllerProvider(
                  searchProductKey,
                ).select((state) => state.isLoading),
              ),
              searchProducts: _searchProducts,
            ),
            gapH8,
            Expanded(
              child: Consumer(
                builder: (_, ref, _) {
                  final productsState = ref.watch(
                    searchProductsStateControllerProvider(searchProductKey),
                  );

                  return AsyncValueWidget(
                    value: productsState,
                    tryAgain: null,
                    data: (products) {
                      return ResponsiveListFlow(
                        itemCount: products.length,
                        itemBuilder: (_, index) {
                          final product = products[index];
                          return ProductItemWidget(
                            product: product,
                            routine: BsRoutine.adjustSalePrice,
                            notClickableBottom: Padding(
                              padding: const EdgeInsets.only(top: Sizes.p8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: PrimaryButton(
                                      text: 'Alterar preços'.hardcoded,
                                      icon: Icon(
                                        theme.platform == TargetPlatform.iOS
                                            ? CupertinoIcons.pencil
                                            : Icons.edit,
                                      ),
                                      iconAlignment: IconAlignment.end,
                                      onPressed: () {
                                        context.goNamed(
                                          Routes.adjustSalePrice.name,
                                          pathParameters: {
                                            'enterpriseCode': widget
                                                .enterpriseCode
                                                .toString(),
                                            'plu': product.PLU!,
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
