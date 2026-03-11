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
    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(customersStateControllerProvider(enterpriseCode)),
      tryAgain: null,
      data: (customers) {
        return ResponsiveListFlow(
          isSliver: true,
          itemCount: customers.length,
          itemBuilder: (_, index) {
            final customer = customers[index];
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
