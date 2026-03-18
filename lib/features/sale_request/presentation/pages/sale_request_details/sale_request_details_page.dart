import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../localization/string_hardcoded.dart';

class SaleRequestDetailsPage extends ConsumerWidget {
  final int saleRequestId;
  final int enterpriseCode;
  const SaleRequestDetailsPage({
    super.key,
    required this.saleRequestId,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do pedido'.hardcoded)),
      body: const Placeholder(),
    );
  }
}
