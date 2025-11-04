import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class CustomerPage extends ConsumerWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ResponsiveScrollableWidget(
            padding: 0,
            child: SearchFieldAndSwitch(),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                AsyncValueSliverWidget(
                  value: ref.watch(consumerCustomerStasteControllerProvider),
                  tryAgain: () =>
                      ref.invalidate(consumerCustomerStasteControllerProvider),
                  data: (customer) {
                    return SliverToBoxAdapter(
                      child: CustomerItem(
                        customer: customer!,
                        isConsumerCustomer: true,
                      ),
                    );
                  },
                ),
                gapSliverH8,
                AsyncValueSliverWidget(
                  value: ref.watch(customersStateControllerProvider),
                  tryAgain: null,
                  data: (customers) {
                    return ResponsiveListFlow(
                      isSliver: true,
                      itemCount: customers.length,
                      itemBuilder: (_, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomerItem(customer: customers[index]),
                            gapH8,
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
