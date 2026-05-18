import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class SearchedCustomersItems extends ConsumerWidget {
  const SearchedCustomersItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consumerCustomerCode = ref.watch(
      consumerCustomerStateControllerProvider.select((s) => s.value?.code),
    );

    return AsyncValueWidget(
      value: ref.watch(searchedCustomersStateControllerProvider),
      tryAgain: null,
      isSliver: true,
      data: (customers) {
        final filteredCustomers = customers
            .where((e) => e.code != consumerCustomerCode)
            .toList();

        return ResponsiveListFlow(
          itemCount: filteredCustomers.length,
          isSliver: true,
          itemBuilder: (context, index) {
            final customer = filteredCustomers[index];
            return CustomerItem(
              key: ValueKey(customer.code),
              customer: customer,
            );
          },
        );
      },
    );
  }
}
