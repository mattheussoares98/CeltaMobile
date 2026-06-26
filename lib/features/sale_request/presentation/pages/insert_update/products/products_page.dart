import 'package:celta_inventario/features/sale_request/presentation/pages/create_sale_request/insert_products/components/search_products.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/insert_update/products/components/components.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SearchProducts(),
        Expanded(child: ProductsList()),
      ],
    );
  }
}
