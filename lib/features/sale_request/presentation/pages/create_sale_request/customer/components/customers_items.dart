import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class CustomersItems extends ConsumerWidget {
  final int enterpriseCode;
  const CustomersItems({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consumerCode = ref.watch(
      consumerCustomerStasteControllerProvider(
        enterpriseCode,
      ).select((s) => s.value?.Code),
    );

    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(customersStateControllerProvider(enterpriseCode)),
      tryAgain: null,
      data: (customers) {
        final filteredCustomers = customers
            .where((x) => x.Code != consumerCode)
            .toList();

        return ResponsiveListFlow(
          isSliver: true,
          itemCount: filteredCustomers.length,
          itemBuilder: (_, index) {
            final customer = filteredCustomers[index];
            return CustomerItem(
              key: ValueKey(customer.Code),
              customer: customer,
              enterpriseCode: enterpriseCode,
            );
          },
        );
      },
    );
  }
}
