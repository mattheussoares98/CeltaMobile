import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../domain/entity/entity.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final int receiptCode;
  final ReceiptEntity? receipt;
  final int enterpriseCode;
  const ProductsPage({
    super.key,
    required this.receiptCode,
    required this.receipt,
    required this.enterpriseCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final searchValueController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchValueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StringBuffer? buffer;
    if (widget.receipt != null) {
      buffer = StringBuffer(
        '[${widget.receipt!.Numero_ProcRecebDoc.toString()}]',
      );
      if (widget.receipt!.EmitterName != null) {
        buffer.write(' ${widget.receipt!.EmitterName}');
      }
    }

    final asyncValue = ref.watch(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.goodsReceiving,
        Modules.receipt,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(buffer?.toString() ?? 'Produtos'.hardcoded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          children: [
            DefaultSearchProducts(
              isLoading: asyncValue.isLoading,
              searchProducts: () {
                ref
                    .read(
                      searchProductsStateControllerProvider(
                        widget.enterpriseCode,
                        BsRoutine.goodsReceiving,
                        Modules.receipt,
                      ).notifier,
                    )
                    .loadProducts(
                      searchValue: searchValueController.text,
                      enterpriseCodes: [widget.enterpriseCode],
                    );
              },
              searchValueController: searchValueController,
            ),
            gapH8,
            Expanded(
              child: AsyncValueWidget(
                value: asyncValue,
                tryAgain: () => ref.invalidate(
                  searchProductsStateControllerProvider(
                    widget.enterpriseCode,
                    BsRoutine.goodsReceiving,
                    Modules.receipt,
                  ),
                ),
                data: (products) {
                  return ResponsiveListFlow(
                    itemCount: products.length,
                    itemBuilder: (_, index) {
                      final product = products[index];

                      return ProductItemWidget(
                        product: product,
                        routine: BsRoutine.goodsReceiving,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
