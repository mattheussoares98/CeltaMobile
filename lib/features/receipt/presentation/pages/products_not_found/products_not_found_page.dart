import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsNotFoundPage extends ConsumerStatefulWidget {
  const ProductsNotFoundPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductsNotFoundPageState();
}

class _ProductsNotFoundPageState extends ConsumerState<ProductsNotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Produtos não encontrados'.hardcoded)),
    );
  }
}
