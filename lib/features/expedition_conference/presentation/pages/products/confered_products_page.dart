import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/pages/products/components/components.dart';

class ConferedProductsPage extends ConsumerWidget {
  final int expeditionControlCode;
  const ConferedProductsPage({super.key, required this.expeditionControlCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannedProducts = ref.watch(
      expeditionConferenceControllerProvider(
        expeditionControlCode,
      ).select((s) => s.value?.scannedProducts),
    );

    if (scannedProducts == null || scannedProducts.isEmpty) {
      return Center(
        child: Text('Nenhum produto conferido até o momento'.hardcoded),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: ResponsiveListFlow(
        itemCount: scannedProducts.length,
        itemBuilder: (_, index) {
          final product = scannedProducts[index];
          return ProductItem(
            key: ValueKey(product.ProductPackingCode),
            product: product,
            expeditionControlCode: expeditionControlCode,
            isPending: false,
          );
        },
      ),
    );
  }
}
