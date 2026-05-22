import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/commom_widgets/search_product/components/components.dart';

class DefaultSearchProducts extends ConsumerWidget {
  final void Function(int? exactProductCode) searchProducts;
  final TextEditingController searchValueController;
  final FocusNode? focusNode;
  final bool? allowEmptySearchValue;
  final bool? isLoading;
  final SearchProductKey searchProductKey;

  const DefaultSearchProducts({
    super.key,
    required this.searchProducts,
    required this.searchValueController,
    required this.searchProductKey,
    this.focusNode,
    this.allowEmptySearchValue,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(searchProductsStateControllerProvider(searchProductKey), (p, n) {
      n.doOnSuccess(p, () {
        ShallowProductsOverlay.hide();
        searchValueController.clear();
      });
    });

    return RepaintBoundary(
      child: SizedBox(
        width: Breakpoint.desktop,
        child: Padding(
          padding: const EdgeInsets.only(top: Sizes.p4),
          child: SearchField(
            isLoading: isLoading,
            searchProductKey: searchProductKey,
            searchValueController: searchValueController,
            focusNode: focusNode,
            searchProducts: searchProducts,
            allowEmptySearchValue: allowEmptySearchValue,
          ),
        ),
      ),
    );
  }
}
