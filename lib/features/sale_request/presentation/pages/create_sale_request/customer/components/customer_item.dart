import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class CustomerItem extends ConsumerWidget {
  final CustomerEntity customer;
  final bool isConsumerCustomer;
  final int enterpriseCode;
  const CustomerItem({
    super.key,
    required this.customer,
    required this.enterpriseCode,
    this.isConsumerCustomer = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCustomer = ref.watch(
      pendingSaleRequestStateControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.customer),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.p8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          CustomerInfoAndRadio(
            customerItem: this,
            enterpriseCode: enterpriseCode,
            changeSelectedCustomer: () => ref
                .read(
                  pendingSaleRequestStateControllerProvider(
                    enterpriseCode,
                  ).notifier,
                )
                .changeCustomer(customer),
          ),
          if (customer == selectedCustomer &&
              customer.CustomerCovenants != null &&
              customer.CustomerCovenants!.isNotEmpty) ...[
            Covenants(customerItem: this, enterpriseCode: enterpriseCode),
          ],
        ],
      ),
    );
  }
}
