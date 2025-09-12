import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdjustSalePricePage extends ConsumerWidget {
  final int enterpriseCode;
  const AdjustSalePricePage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Ajuste de preços'.hardcoded)),
    );
  }
}
