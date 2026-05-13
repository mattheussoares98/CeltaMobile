import 'package:flutter/material.dart';

import 'components/components.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SearchCustomerField()),
        SelectedCustomerItem(),
        SearchedCustomersItems(),
      ],
    );
  }
}
