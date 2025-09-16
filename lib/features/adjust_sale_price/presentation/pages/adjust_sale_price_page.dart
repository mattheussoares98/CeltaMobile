import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../core/domain/entities/entities.dart';
import '../controllers/controllers.dart';

class AdjustSalePricePage extends ConsumerWidget {
  final String plu;
  final int enterpriseCode;
  final ProductEntity? product;
  final EnterpriseEntity? enterprise;
  const AdjustSalePricePage({
    super.key,
    required this.plu,
    required this.enterpriseCode,
    required this.product,
    required this.enterprise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProductAsync = ref.watch(
      selectedProductStateControllerProvider(enterpriseCode, plu, product),
    );

    return Scaffold(
      appBar: AppBar(),
      body: AsyncValueWidget(
        value: selectedProductAsync,
        tryAgain: () {
          ref.invalidate(
            selectedProductStateControllerProvider(
              enterpriseCode,
              plu,
              product,
            ),
          );
        },
        data: (product) {
          return Text(product!.Name);
        },
      ),
    );
  }
}
