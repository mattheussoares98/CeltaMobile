import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../create_sale_request/insert_products/components/search_products.dart';
import 'components/components.dart';

class ProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  const ProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchProductKey = SearchProductKey(
      enterpriseCode,
      BsRoutine.saleRequest,
      Modules.saleRequest,
      anotherKey: saleRequestId.toString(),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
          child: SearchProducts(searchProductKey: searchProductKey),
        ),
        Expanded(
          child: ProductsList(
            searchProductKey: searchProductKey,
            customerCode: customerCode,
          ),
        ),
      ],
    );
  }
}
