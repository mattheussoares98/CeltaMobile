import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../controllers/controllers.dart';

class SearchProducts extends ConsumerWidget {
  final FocusNode searchProductsFocusNode;
  final TextEditingController searchProductsController;
  final int enterpriseCode;
  final int codigoInternoInventario;
  final int codigoInternoInvCont;
  final VoidCallback searchProducts;
  const SearchProducts({
    super.key,
    required this.searchProducts,
    required this.searchProductsController,
    required this.searchProductsFocusNode,
    required this.enterpriseCode,
    required this.codigoInternoInventario,
    required this.codigoInternoInvCont,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      inventoryProductsStateControllerProvider(
        enterpriseCode,
        codigoInternoInventario,
        codigoInternoInvCont,
      ).select((state) => state.isLoading),
    );
    return SliverToBoxAdapter(
      child: DefaultSearchProducts(
        focusNode: searchProductsFocusNode,
        isLoading: isLoading,
        searchProducts: searchProducts,
        searchValueController: searchProductsController,
      ),
    );
  }
}
