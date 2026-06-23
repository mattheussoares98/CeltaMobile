import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/create_sale_request/insert_products/components/components.dart';
import 'package:flutter/material.dart';

class InsertProductsPage extends StatelessWidget {
  final int enterpriseCode;
  final BSFRequestTypeEntity selectedRequest;
  const InsertProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.selectedRequest,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.p4),
      child: Column(
        children: [
          SearchProducts(),
          gapH8,
          Expanded(
            child: CustomScrollView(slivers: [ProductsItems(), gapSliverH48]),
          ),
        ],
      ),
    );
  }
}
