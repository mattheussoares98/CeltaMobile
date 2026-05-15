import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../providers.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class SearchedCustomersItems extends ConsumerWidget {
  const SearchedCustomersItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCustomerCode = ref.watch(
      saleRequestDetailsStateControllerProvider(
        ref.read(saleRequestArgsProvider),
      ).select((s) => s.value?.customer?.code),
    );

    final filteredCustomers = ref.watch(
      searchedCustomersStateControllerProvider.select(
        (s) => s.value?.where((c) => c.code != selectedCustomerCode),
      ),
    );
    return AsyncValueWidget(
      value: ref.watch(searchedCustomersStateControllerProvider),
      tryAgain: null,
      isSliver: true,
      data: (customers) {
        return ResponsiveListFlow(
          itemCount: filteredCustomers!.length,
          isSliver: true,
          itemBuilder: (context, index) {
            final customer = filteredCustomers.toList()[index];
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
