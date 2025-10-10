import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsConferencePage extends ConsumerWidget {
  final int expeditionControlCode;
  final int stepCode;
  const ProductsConferencePage({
    super.key,
    required this.expeditionControlCode,
    required this.stepCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Documentos'.hardcoded)),
      body: Center(child: Text('Documentos'.hardcoded)),
    );
  }
}
