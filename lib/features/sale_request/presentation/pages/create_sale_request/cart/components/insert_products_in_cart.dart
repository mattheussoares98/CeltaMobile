import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class InsertProductsInCart extends StatelessWidget {
  const InsertProductsInCart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        'Insira produtos no carrinho'.hardcoded,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleMedium?.copyWith(
          color: Colors.red,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
