import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          child: ResponsiveCenter(
            child: CustomerItem(
              key: ValueKey(customer.code),
              customer: customer,
            ),
          ),
        );
      },
    );
  }
}
