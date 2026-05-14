import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';

class CustomerItem extends ConsumerWidget {
  final BSFCustomerEntity customer;
  const CustomerItem({super.key, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      insertUpdateStateControllerProvider.select(
        (s) => s.value?.customer?.code == customer.code,
      ),
    );

    return DefaultCheckBox(
      name: customer.name ?? '',
      subtitle: customer.cnpjCpfNumber ?? '',
      enabled: enabled,
      onChanged: (_) {
        ref
            .read(insertUpdateStateControllerProvider.notifier)
            .updateCustomer(customer);
      },
    );
  }
}
