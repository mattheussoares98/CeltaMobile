import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/presentation/pages/products_management/insert_products/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Column(
      children: [
        Consumer(
          builder: (_, ref, _) {
            return DefaultSearchProducts(
              searchProductKey: searchProductKey,
              focusNode: searchValueFocusNode,
              searchProducts: (exactProductCode) {
                ref
                    .read(
                      searchProductsStateControllerProvider(
                        searchProductKey,
                      ).notifier,
                    )
                    .loadProducts(
                      exactProductCode: exactProductCode,
                      GetProductsByRequestTypeParams(
                        searchValue: searchValueController.text,
                        enterpriseOriginCode: widget.draftKey.enterpriseOrigin,
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
    );
  }
}
