import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../providers.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class SelectedCustomerItem extends ConsumerWidget {
  const SelectedCustomerItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ref.watch(saleRequestArgsProvider);
    final selectedCustomer = ref.watch(
      saleRequestDetailsStateControllerProvider(
        args,
      ).select((s) => s.value?.customer),
    );
    if (selectedCustomer != null) {
      return SliverToBoxAdapter(
        child: CustomerItem(
          key: ValueKey(selectedCustomer.code),
          customer: selectedCustomer,
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
