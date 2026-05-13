import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/domain/entities/entities.dart';

class CustomerItem extends ConsumerWidget {
  final BSFCustomerEntity customer;
  const CustomerItem({super.key, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(customer.name ?? ''),
      subtitle: Text(customer.cnpjCpfNumber ?? ''),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {},
    );
  }
}
