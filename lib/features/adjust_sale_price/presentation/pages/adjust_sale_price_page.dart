import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdjustSalePricePage extends ConsumerWidget {
  final String plu;
  const AdjustSalePricePage({super.key, required this.plu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: AppBar(), body: const Placeholder());
  }
}
