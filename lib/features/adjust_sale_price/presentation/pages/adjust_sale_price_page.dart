import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../controllers/controllers.dart';

class AdjustSalePricePage extends ConsumerWidget {
  final String plu;
  final int enterpriseCode;
  const AdjustSalePricePage({
    super.key,
    required this.plu,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProductAsync = ref.watch(
      selectedProductStateControllerProvider(enterpriseCode, plu),
    );

    return Scaffold(
      appBar: AppBar(),
      body: AsyncValueWidget(
        value: selectedProductAsync,
        tryAgain: () {
          ref.invalidate(
            selectedProductStateControllerProvider(enterpriseCode, plu),
          );
        },
        data: (product) {
          return Text(product!.Name);
        },
      ),
    );
  }
}
