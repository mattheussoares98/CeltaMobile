import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/data/datasource/datasource.dart';
import '../../../../features/adjust_sale_price/presentation/controllers/controllers.dart';
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
          searchProductsStateControllerProvider(widget.enterpriseCode).notifier,
        )
        .loadProducts(
          enterpriseCode: widget.enterpriseCode,
          searchValue: searchValueController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(searchProductsStateControllerProvider(widget.enterpriseCode), (
      previous,
      next,
    ) {
      next.doOnSuccess(previous, () {
        searchValueController.clear();
      });
    });

    final productsState = ref.watch(
      searchProductsStateControllerProvider(widget.enterpriseCode),
    );

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        title: FittedBox(child: Text("Produtos (ajuste de preço)".hardcoded)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p4),
        child: Column(
          children: [
            DefaultSearchProducts(
              searchValueController: searchValueController,
              isLoading: productsState.isLoading,
              searchProducts: _searchProducts,
            ),
            gapH8,
            Expanded(
              child: AsyncValueWidget(
                value: productsState,
                tryAgain: null,
                data: (products) {
                  return ResponsiveListFlow(
                    itemCount: products.length,
                    itemBuilder: (_, index) {
                      final product = products[index];
                      return ProductItemWidget(
                        enterpriseCode: widget.enterpriseCode,
                        product: product,
                        routine: Routine.adjustSalePrice,
                        bottom: Padding(
                          padding: const EdgeInsets.only(top: Sizes.p8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: PrimaryTextButton(
                                  text: 'Alterar preços'.hardcoded,
                                  icon: Icon(
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? CupertinoIcons.pencil
                                        : Icons.edit,
                                  ),
                                  iconAlignment: IconAlignment.end,
                                  onPressed: () {
                                    context.pushNamed(
                                      AppRoute.adjustSalePrice.name,
                                      pathParameters: {
                                        'enterpriseCode': widget.enterpriseCode
                                            .toString(),
                                        'plu': product.PLU,
                                      },
                                      extra: product,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
