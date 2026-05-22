import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/insert_update.dart';

class InsertUpdateBody extends ConsumerWidget {
  const InsertUpdateBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageIndexStateControllerProvider);

    return IndexedStack(
      index: pageIndex,
      children: const [
        ProductsPage(),
        CustomersPage(),
        SellersPage(),
        ItemsPage(),
        PaymentsPage(),
        SummaryPage(),
      ],
    );
  }
}
