import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../localization/string_hardcoded.dart';
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
        if (customers.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: Sizes.p16),
              child: Text(
                'Nenhum cliente foi encontrado'.hardcoded,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

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
