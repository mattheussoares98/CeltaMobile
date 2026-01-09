import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/supplier/supplier.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class SupplierItems extends ConsumerWidget {
  const SupplierItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    if (pendingAsync.isLoading) {
      return const SliverToBoxAdapter(child: LoadingWidget());
    }

    final suppliers = ref.watch(
      uiStateControllerProvider.select((s) => s.value?.suppliers ?? []),
    );

    final suppliersState = ref.watch(
      supplierStateControllerProvider(SearchSupplierType.buyRequest),
    );

    return SliverList.builder(
      itemCount: suppliersState.value?.length ?? suppliers.length,
      itemBuilder: (_, index) {
        final supplier = suppliersState.value?[index] ?? suppliers[index];
        return SupplierItem(supplier: supplier, pending: pendingAsync.value);
      },
    );
  }
}
