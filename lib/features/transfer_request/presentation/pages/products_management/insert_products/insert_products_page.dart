import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/products/products.dart';
import '../../../../domain/entities/entities.dart';
import 'components/components.dart';

class InsertProductsPage extends ConsumerStatefulWidget {
  final DraftKey draftKey;
  const InsertProductsPage({super.key, required this.draftKey});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InsertProductsPageState();
}

class _InsertProductsPageState extends ConsumerState<InsertProductsPage> {
  final searchValueController = TextEditingController();
  final searchValueFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    searchValueController.dispose();
    searchValueFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProductKey = SearchProductKey(
      widget.draftKey.enterpriseOrigin,
      BsRoutine.transferRequest,
      Modules.transferRequest,
      anotherKey:
          '${widget.draftKey.enterpriseOrigin}-${widget.draftKey.enterpriseDestinyCode}-${widget.draftKey.requestTypeCode}',
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: Column(
        children: [
          Consumer(
            builder: (_, ref, _) {
              return DefaultSearchProducts(
                isLoading: ref.watch(
                  searchProductsStateControllerProvider(
                    searchProductKey,
                  ).select((value) => value.isLoading),
                ),
                searchProductKey: searchProductKey,
                focusNode: searchValueFocusNode,
                searchProducts: () {
                  ref
                      .read(
                        searchProductsStateControllerProvider(
                          searchProductKey,
                        ).notifier,
                      )
                      .loadProducts(
                        GetProductsByRequestTypeParams(
                          searchValue: searchValueController.text,
                          enterpriseOriginCode:
                              widget.draftKey.enterpriseOrigin,
                          enterpriseDestinyCode:
                              widget.draftKey.enterpriseDestinyCode,
                          requestTypeCode: widget.draftKey.requestTypeCode,
                        ),
                      );
                },
                searchValueController: searchValueController,
              );
            },
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                gapSliverH8,
                ProductsItems(
                  draftKey: widget.draftKey,
                  searchProductKey: searchProductKey,
                ),
                gapSliverH48,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
