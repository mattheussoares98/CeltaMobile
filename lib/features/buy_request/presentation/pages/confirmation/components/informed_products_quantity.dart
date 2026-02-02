import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';
import 'components.dart';

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
