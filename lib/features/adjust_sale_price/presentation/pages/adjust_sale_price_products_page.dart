import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdjustSalePriceProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  const AdjustSalePriceProductsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      isScrollable: false,
      usePadding: true,
      appBar: BaseAppBar(
        title: 'Produtos (ajuste de preços)'.hardcoded,
        selectedEnterpriseCode: enterpriseCode,
      ),
      body: const Column(
        children: [
          SearchProduct(),
          gapH8,
          Expanded(child: ProductsItems()),
        ],
      ),
    );
  }
}
