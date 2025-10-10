import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  const SearchProductsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Pesquisar produtos'.hardcoded)),
      body: Center(child: Text('Pesquisar produtos'.hardcoded)),
    );
  }
}
