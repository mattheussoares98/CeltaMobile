import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../controllers/controllers.dart';
import 'components.dart';

class ConsumerCustomer extends ConsumerWidget {
  final int enterpriseCode;
  const ConsumerCustomer({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool internalCostumerDoesntExist = ref.watch(
      consumerCustomerStasteControllerProvider(enterpriseCode).select(
        (s) => s.error.toString().toLowerCase().contains(
          'o número de documento informado não foi encontrado',
        ),
      ),
    );

    if (internalCostumerDoesntExist) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return AsyncValueWidget(
      isSliver: true,
      value: ref.watch(
        consumerCustomerStasteControllerProvider(enterpriseCode),
      ),
      tryAgain: () => ref.invalidate(consumerCustomerStasteControllerProvider),
      data: (customer) {
        return SliverToBoxAdapter(
          child: CustomerItem(
            key: ValueKey(customer?.Code),
            customer: customer!,
            isConsumerCustomer: true,
            enterpriseCode: enterpriseCode,
          ),
        );
      },
    );
  }
}
