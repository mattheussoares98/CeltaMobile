import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class CustomerPage extends ConsumerStatefulWidget {
  const CustomerPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomerPageState();
}

class _CustomerPageState extends ConsumerState<CustomerPage> {
  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersStateControllerProvider);
    final consumerCustomerAsync = ref.watch(
      consumerCustomerStasteControllerProvider,
    );

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
                  value: consumerCustomerAsync,
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
                  value: customersAsync,
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
