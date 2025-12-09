import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../controllers/controllers.dart';

class ProductsNotFoundPage extends ConsumerWidget {
  final int receiptCode;
  const ProductsNotFoundPage({super.key, required this.receiptCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Produtos não encontrados'.hardcoded)),
      body: AsyncValueWidget(
        value: ref.watch(productsNotFoundStateControllerProvider(receiptCode)),
        tryAgain: () => ref.invalidate(
          productsNotFoundStateControllerProvider(receiptCode),
        ),
        data: (products) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                productsNotFoundStateControllerProvider(receiptCode),
              );
            },
            child: ResponsiveListFlow(
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Column(children: [Text(product.ean)]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
