import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsPage extends ConsumerWidget {
  final int codigoInternoInvCont;
  const ProductsPage({super.key, required this.codigoInternoInvCont});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: AppBar(title: Text('Produtos'.hardcoded)));
  }
}
