import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../features/adjust_sale_price/presentation/controllers/controllers.dart';

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

  Future<void> searchProducts() async {
    await ref
        .read(productsStateControllerProvider(widget.enterpriseCode).notifier)
        .loadProducts(
          enterpriseCode: widget.enterpriseCode,
          searchValue: searchValueController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(productsStateControllerProvider(widget.enterpriseCode), (
      previous,
      next,
    ) {
      next.doOnSuccess(previous, () {
        searchValueController.clear();
      });
    });

    final productsState = ref.watch(
      productsStateControllerProvider(widget.enterpriseCode),
    );

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text("Produtos (ajuste de preço)".hardcoded)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          children: [
            DefaultSearchProducts(
              searchValueController: searchValueController,
              isLoading: productsState.isLoading,
              searchProducts: searchProducts,
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
                      final e = products[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: Sizes.p8),
                        child: Padding(
                          padding: const EdgeInsets.all(Sizes.p8),
                          child: Text(e.Name),
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
