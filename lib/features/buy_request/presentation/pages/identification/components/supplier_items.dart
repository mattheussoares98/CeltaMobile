import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class SupplierItems extends ConsumerWidget {
  final AsyncValue<List<SupplierEntity>?> suppliersState;
  final List<SupplierEntity> suppliers;
  const SupplierItems({
    super.key,
    required this.suppliersState,
    required this.suppliers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    if (pendingAsync.isLoading) {
      return SliverToBoxAdapter(child: LoadingWidget());
    }

    return SliverList.builder(
      itemCount: suppliersState.value?.length ?? suppliers.length,
      itemBuilder: (_, index) {
        final supplier = suppliersState.value?[index] ?? suppliers[index];
        return SupplierItem(supplier: supplier, pending: pendingAsync.value);
      },
    );
  }
}
