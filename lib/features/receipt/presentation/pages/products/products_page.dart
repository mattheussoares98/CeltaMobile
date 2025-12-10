import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../utils/utils.dart';
import '../../../domain/entity/entity.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

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

  void searchProduct(
    SearchProductKey searchProductKey, {
    SearchType? searchType,
  }) async {
    ref
        .read(searchProductsStateControllerProvider(searchProductKey).notifier)
        .loadProducts(
          GetProductsReceiptParams(
            searchValue: searchValueController.text,
            grDocCode: widget.receiptCode,
          ),
          specifiedSearchType: searchType,
        );
  }

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

    final searchProductKey = SearchProductKey(
      widget.enterpriseCode,
      BsRoutine.goodsReceiving,
      Modules.receipt,
    );

    ref.listen(searchProductsStateControllerProvider(searchProductKey), (p, n) {
      n.doOnSuccess(p, () {
        searchValueController.clear();
      });
    });

    final asyncValue = ref.watch(
      searchProductsStateControllerProvider(searchProductKey),
    );

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(buffer?.toString() ?? 'Produtos'.hardcoded),
        ),
      ),
      body: Column(
        children: [
          TopButtons(
            searchProduct: (searchType) =>
                searchProduct(searchProductKey, searchType: searchType),
            enterpriseCode: widget.enterpriseCode,
            receiptCode: widget.receiptCode,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p8,
                0,
                Sizes.p8,
                Sizes.p8,
              ),
              child: Column(
                children: [
                  DefaultSearchProducts(
                    isLoading: asyncValue.isLoading,
                    searchProducts: () {
                      searchProduct(searchProductKey);
                    },
                    searchValueController: searchValueController,
                  ),
                  gapH8,
                  Expanded(
                    child: AsyncValueWidget(
                      value: asyncValue,
                      tryAgain: null,
                      data: (products) {
                        return ResponsiveListFlow(
                          itemCount: products.length,
                          itemBuilder: (_, index) {
                            final product = products[index];

                            return ProductItemWidget(
                              product: product,
                              routine: BsRoutine.goodsReceiving,
                              showDropIcon: true,
                              isSelected:
                                  ref.watch(
                                    selectedProductIndeStateControllerProvider,
                                  ) ==
                                  index,
                              onTap: () {
                                ref
                                    .read(
                                      selectedProductIndeStateControllerProvider
                                          .notifier,
                                    )
                                    .updateIndex(index);
                              },
                              clickableBottom: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleAndSubTitle(
                                    title: 'Validade'.hardcoded,
                                    subTitle:
                                        product.DataValidade_ProcRecebDocProEmb ==
                                            null
                                        ? null
                                        : DateFormat('dd/MM/yyyy').format(
                                            product
                                                .DataValidade_ProcRecebDocProEmb!,
                                          ),
                                    emptyMessage: 'Sem validade'.hardcoded,
                                  ),
                                  TitleAndSubTitle(
                                    title: 'Quantidade contada'.hardcoded,
                                    subTitle:
                                        product.Quantidade_ProcRecebDocProEmb,
                                    emptyMessage:
                                        'Sem quantidade contada'.hardcoded,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
