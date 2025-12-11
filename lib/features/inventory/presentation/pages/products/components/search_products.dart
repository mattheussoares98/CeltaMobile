import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';

class SearchProducts extends ConsumerWidget {
  final FocusNode searchProductsFocusNode;
  final TextEditingController searchProductsController;
  final int enterpriseCode;
  final int codigoInternoInventario;
  final int codigoInternoInvCont;
  final VoidCallback searchProducts;
  final SearchProductKey searchProductKey;
  const SearchProducts({
    super.key,
    required this.searchProducts,
    required this.searchProductsController,
    required this.searchProductsFocusNode,
    required this.enterpriseCode,
    required this.codigoInternoInventario,
    required this.codigoInternoInvCont,
    required this.searchProductKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      searchProductsStateControllerProvider(
        searchProductKey,
      ).select((state) => state.isLoading),
    );
    return SliverToBoxAdapter(
      child: DefaultSearchProducts(
        focusNode: searchProductsFocusNode,
        isLoading: isLoading,
        searchProducts: searchProducts,
        searchValueController: searchProductsController,
        searchProductKey: searchProductKey,
      ),
    );
  }
}
