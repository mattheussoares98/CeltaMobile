import 'package:celta_inventario/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/customer/components/components.dart';

class CustomersPage extends ConsumerWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SearchCustomerField()),
          ConsumerCustomer(),
          SearchedCustomersItems(),
        ],
      ),
    );
  }
}
