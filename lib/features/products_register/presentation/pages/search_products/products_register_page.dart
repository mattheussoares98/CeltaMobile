import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/app_sizes.dart';
import 'package:celta_inventario/features/products_register/presentation/pages/search_products/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchProductsPage extends ConsumerWidget {
  final int enterpriseCode;
  const SearchProductsPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      appBar: BaseAppBar(
        title: context.l10n.coreModulesProductsRegister,
        selectedEnterpriseCode: enterpriseCode,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SearchProductField(enterpriseCode: enterpriseCode),
            ),
            ProductsItems(enterpriseCode: enterpriseCode),
          ],
        ),
      ),
    );
  }
}
