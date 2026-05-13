import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/controllers.dart';
import 'components.dart';

class SelectedCustomerItem extends ConsumerWidget {
  final int customerCode;
  final int enterpriseCode;
  final int saleRequestId;
  const SelectedCustomerItem({
    super.key,
    required this.customerCode,
    required this.enterpriseCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCustomer = ref.watch(
      saleRequestDetailsStateControllerProvider(
        customerCode: customerCode,
        enterpriseCode: enterpriseCode,
        saleRequestCode: saleRequestId,
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
