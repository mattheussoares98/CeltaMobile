import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/confirmation/components/components.dart';

class InformedProductsQuantity extends ConsumerWidget {
  final int enterpriseCode;
  const InformedProductsQuantity({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(
      pendingBuyRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.products?.values),
    );

    if (products?.isEmpty ?? true) {
      return UnselectedMessage(
        title: 'Adicione pelo menos um produto'.hardcoded,
      );
    }

    return SliverToBoxAdapter(
      child: DefaultSmallTitle(
        title: 'Produtos (${products!.length})'.hardcoded,
      ),
    );
  }
}
