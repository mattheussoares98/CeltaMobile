import 'package:celta_inventario/constants/constants.dart';
import 'package:flutter/material.dart';

import 'components/components.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SearchCustomerField()),
          SearchedCustomersItems(),
        ],
      ),
    );
  }
}
