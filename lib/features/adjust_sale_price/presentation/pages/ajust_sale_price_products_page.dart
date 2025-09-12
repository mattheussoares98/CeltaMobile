import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdjustSalePriceProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  const AdjustSalePriceProductsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Ajuste de preços'.hardcoded)),
    );
  }
}
