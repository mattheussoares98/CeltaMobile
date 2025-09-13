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
        .read(productsStateControllerProvider.notifier)
        .loadProducts(
          enterpriseCode: widget.enterpriseCode,
          searchValue: searchValueController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(productsStateControllerProvider, (previous, next) {
      next.doOnSuccess(previous, () {
        searchValueController.clear();
      });
    });

    final productsState = ref.watch(productsStateControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text("Produtos (ajuste de preço)".hardcoded)),
      ),
      body: ResponsiveScrollableWidget(
        maxContentWidth: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultSearchProducts(
              searchValueController: searchValueController,
              isLoading: productsState.isLoading,
              searchProducts: () {
                searchProducts();
              },
            ),
            gapH16,
            AsyncValueWidget(
              value: productsState,
              tryAgain: null,
              data: (products) {
                return ResponsiveFlowLayout(
                  //TODO use a better widget with performance
                  maxItemWidth: 300,
                  spacing: 0,
                  runSpacing: 0,
                  items: productsState.value!.map((e) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.p8),
                        child: Text(e.Name),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
