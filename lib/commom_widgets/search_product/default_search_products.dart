import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import '../../core/domain/entities/entities.dart';
import '../../core/presentation/controllers/products/products.dart';
import '../../utils/utils.dart';
import '../commom_widgets.dart';
import 'components/components.dart';

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
