import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class SearchedCustomersItems extends ConsumerWidget {
  const SearchedCustomersItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consumerCustomerCode = ref.watch(
      consumerCustomerStateControllerProvider.select((s) => s.value?.code),
    );
    final theme = Theme.of(context);

    return AsyncValueWidget(
      value: ref.watch(searchedCustomersStateControllerProvider),
      tryAgain: null,
      isSliver: true,
      data: (searchState) {
        final filteredCustomers = searchState.customers
            .where((e) => e.code != consumerCustomerCode)
            .toList();

        return SliverMainAxisGroup(
          slivers: [
            ResponsiveListFlow(
              itemCount: filteredCustomers.length,
              isSliver: true,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
                return CustomerItem(
                  key: ValueKey(customer.code),
                  customer: customer,
                );
              },
            ),
            if (searchState.errorMessage != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                  child: Center(
                    child: Text(
                      searchState.errorMessage!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
