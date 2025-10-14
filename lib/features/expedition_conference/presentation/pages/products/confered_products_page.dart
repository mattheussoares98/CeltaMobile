import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';
import 'components/components.dart';

class ConferedProductsPage extends ConsumerWidget {
  final List<ExpeditionProductEntity>? scannedProducts;
  const ConferedProductsPage({super.key, required this.scannedProducts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (scannedProducts == null || scannedProducts!.isEmpty) {
      return Center(
        child: Text('Nenhum produto conferido até o momento'.hardcoded),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: ListView.builder(
        itemCount: scannedProducts!.length,
        itemBuilder: (_, index) {
          final product = scannedProducts![index];
          return ProductItem(product: product);
        },
      ),
    );
  }
}
