import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class CustomerItem extends ConsumerWidget {
  final CustomerEntity customer;
  final bool isConsumerCustomer;
  final VoidCallback changeSelectedCustomer;
  const CustomerItem({
    super.key,
    required this.customer,
    required this.changeSelectedCustomer,
    this.isConsumerCustomer = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCustomer = ref.watch(
      pendingSaleRequestStateControllerProvider.select(
        (s) => s.value?.customer,
      ),
    );

    return Card(
      margin: const EdgeInsets.all(0),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          CustomerInfoAndRadio(
            customerItem: this,
            changeSelectedCustomer: changeSelectedCustomer,
          ),
          if (customer == selectedCustomer &&
              customer.CustomerCovenants != null &&
              customer.CustomerCovenants!.isNotEmpty) ...[
            Covenants(customerItem: this),
          ],
        ],
      ),
    );
  }
}
