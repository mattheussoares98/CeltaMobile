import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsPage extends ConsumerWidget {
  final int receiptCode;
  const ProductsPage({super.key, required this.receiptCode});
  //TODO receive the supplier name as extra param

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: AppBar(title: Text('Produtos'.hardcoded)));
  }
}
