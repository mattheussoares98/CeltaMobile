import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/controllers.dart';
import '../insert_update.dart';

class InsertUpdateBody extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;

  const InsertUpdateBody({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageIndexStateControllerProvider);

    return IndexedStack(
      index: pageIndex,
      children: [
        ProductsPage(
          enterpriseCode: enterpriseCode,
          customerCode: customerCode,
          saleRequestId: saleRequestId,
        ),
        CustomersPage(
          enterpriseCode: enterpriseCode,
          customerCode: customerCode,
          saleRequestId: saleRequestId,
        ),
        ItemsPage(
          enterpriseCode: enterpriseCode,
          customerCode: customerCode,
          saleRequestId: saleRequestId,
        ),
        PaymentsPage(
          enterpriseCode: enterpriseCode,
          customerCode: customerCode,
          saleRequestId: saleRequestId,
        ),
        SummaryPage(
          enterpriseCode: enterpriseCode,
          customerCode: customerCode,
          saleRequestId: saleRequestId,
        ),
      ],
    );
  }
}
