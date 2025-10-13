import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class ConferedProductsPage extends StatelessWidget {
  const ConferedProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Produtos Conferidos'.hardcoded)),
      body: Center(child: Text('Produtos conferidos com sucesso!')),
    );
  }
}
