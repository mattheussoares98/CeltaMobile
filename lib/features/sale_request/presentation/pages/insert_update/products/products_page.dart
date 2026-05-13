import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../providers.dart';
import '../../create_sale_request/insert_products/components/search_products.dart';
import 'components/components.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ref.watch(saleRequestArgsProvider);

    final searchProductKey = SearchProductKey(
      args.enterpriseCode,
      BsRoutine.saleRequest,
      Modules.saleRequest,
      anotherKey: args.saleRequestId.toString(),
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
            customerCode: args.customerCode,
          ),
        ),
      ],
    );
  }
}
