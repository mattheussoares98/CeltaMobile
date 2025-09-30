import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../controllers/controllers.dart';

class LotPage extends ConsumerWidget {
  final int enterpriseCode;
  const LotPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lotAsync = ref.watch(lotStateControllerProvider(enterpriseCode));

    return AsyncValueWidget(
      value: lotAsync,
      tryAgain: () {
        ref.invalidate(lotStateControllerProvider(enterpriseCode));
      },
      data: (products) {
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (_, index) {
            final product = products[index];
            return Card(child: Text(product.toString()));
          },
        );
      },
    );
  }
}
