import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/components.dart';

class CustomersPage extends ConsumerWidget {
  final int saleRequestId;
  final int customerCode;
  final int enterpriseCode;
  const CustomersPage({
    super.key,
    required this.saleRequestId,
    required this.customerCode,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SearchCustomerField(
            customerCode: customerCode,
            enterpriseCode: enterpriseCode,
            saleRequestId: saleRequestId,
          ),
        ),
        SelectedCustomerItem(
          customerCode: customerCode,
          enterpriseCode: enterpriseCode,
          saleRequestId: saleRequestId,
        ),
        SearchedCustomersItems(
          customerCode: customerCode,
          enterpriseCode: enterpriseCode,
          saleRequestId: saleRequestId,
        ),
      ],
    );
  }
}
