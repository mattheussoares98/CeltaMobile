import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/create/components/components.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/create/confirmation/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      return UnselectedMessage(title: context.l10n.addProduct);
    }

    return SliverToBoxAdapter(
      child: DefaultSmallTitle(
        title: context.l10n.productsCount(products!.length),
      ),
    );
  }
}
