import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class ConsumerCustomer extends ConsumerWidget {
  const ConsumerCustomer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(consumerCustomerStateControllerProvider),
      tryAgain: () => ref.invalidate(consumerCustomerStateControllerProvider),
      data: (customer) {
        if (customer == null) {
          return const SliverToBoxAdapter(child: SizedBox());
        }
        return SliverToBoxAdapter(
          child: CustomerItem(key: ValueKey(customer.code), customer: customer),
        );
      },
    );
  }
}
