import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class CustomerItem extends ConsumerWidget {
  final CustomerEntity customer;
  final bool isConsumerCustomer;
  const CustomerItem({
    super.key,
    required this.customer,
    this.isConsumerCustomer = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCustomer = ref.watch(
      pendingSaleRequestStateControllerProvider.select(
        (s) => s.value?.customer,
      ),
    );

    return RepaintBoundary(
      child: Card(
        margin: const EdgeInsets.only(bottom: Sizes.p8),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            CustomerInfoAndRadio(
              customerItem: this,
              changeSelectedCustomer: () => ref
                  .read(pendingSaleRequestStateControllerProvider.notifier)
                  .changeCustomer(customer),
            ),
            if (customer == selectedCustomer &&
                customer.CustomerCovenants != null &&
                customer.CustomerCovenants!.isNotEmpty) ...[
              Covenants(customerItem: this),
            ],
          ],
        ),
      ),
    );
  }
}
