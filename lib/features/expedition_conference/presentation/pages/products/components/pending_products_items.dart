import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class PendingProductsItems extends ConsumerWidget {
  final int expeditionControlCode;
  const PendingProductsItems({super.key, required this.expeditionControlCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(
        expeditionConferenceControllerProvider(expeditionControlCode),
      ),
      tryAgain: () => ref.invalidate(
        expeditionConferenceControllerProvider(expeditionControlCode),
      ),
      data: (expedition) {
        return ListView.builder(
          itemCount: expedition.pendingProducts.length,
          itemBuilder: (_, index) {
            final product = expedition.pendingProducts[index];
            return ProductItem(product: product);
          },
        );
      },
    );
  }
}
