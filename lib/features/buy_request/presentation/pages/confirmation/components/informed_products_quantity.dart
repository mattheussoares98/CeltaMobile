import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';
import 'components.dart';

class InformedProductsQuantity extends ConsumerWidget {
  const InformedProductsQuantity({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(
      pendingBuyRequestStateControllerProvider.select(
        (s) => s.value?.products?.values,
      ),
    );

    if (products?.isEmpty ?? true) {
      return UnselectedMessage(title: 'Nenhum produto informado'.hardcoded);
    }

    return SliverToBoxAdapter(
      child: DefaultSmallTitle(
        title: 'Produtos (${products!.length})'.hardcoded,
      ),
    );
  }
}
