import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components/components.dart';

class CustomerPage extends ConsumerStatefulWidget {
  const CustomerPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomerPageState();
}

class _CustomerPageState extends ConsumerState<CustomerPage> {
  final searchCustomerController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    searchCustomerController.dispose();
    super.dispose();
  }

  void changeSelectedCustomer(CustomerEntity customer) {
    ref
        .read(pendingSaleRequestStateControllerProvider.notifier)
        .changeCustomer(customer);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResponsiveScrollableWidget(
            padding: 0,
            child: SearchFieldAndSwitch(
              formKey: formKey,
              searchController: searchCustomerController,
            ),
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
                        changeSelectedCustomer: () =>
                            changeSelectedCustomer(customer),
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
                        final customer = customers[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomerItem(
                              customer: customer,
                              changeSelectedCustomer: () =>
                                  changeSelectedCustomer(customer),
                            ),
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
