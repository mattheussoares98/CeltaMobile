import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/components.dart';

class SearchSaleRequestPage extends ConsumerWidget {
  final int enterpriseCode;
  const SearchSaleRequestPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Busca de pedidos'.hardcoded)),
      body: Column(
        children: [
          SaleRequestFilters(enterpriseCode: enterpriseCode),
          Expanded(child: RequestsItems(enterpriseCode: enterpriseCode)),
        ],
      ),
    );
  }
}
