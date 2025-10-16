import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/products/products.dart';
import '../../../enterprise_manager/domain/entities/entities.dart';
import '../controllers/controllers.dart';

class SearchProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const SearchProductsPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchProductsPageState();
}

class _SearchProductsPageState extends ConsumerState<SearchProductsPage> {
  final searchValueController = TextEditingController();
  int? lastChangedIndex;

  @override
  void dispose() {
    searchValueController.dispose();
    super.dispose();
  }

  Future<void> searchProducts() async {
    await ref
        .read(
          searchProductsStateControllerProvider(
            widget.enterpriseCode,
            BsRoutine.priceConference,
            Modules.searchProducts,
          ).notifier,
        )
        .loadProducts(
          enterpriseCode: widget.enterpriseCode,
          searchValue: searchValueController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.priceConference,
        Modules.searchProducts,
      ),
    );

    ref.listen(
      searchProductsStateControllerProvider(
        widget.enterpriseCode,
        BsRoutine.priceConference,
        Modules.searchProducts,
      ),
      (p, n) {
        n.doOnSuccess(p, () {
          searchValueController.clear();
        });
      },
    );

    final sendToPrintAsync = ref.watch(sendToPrintControllerProvider);

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(title: Text('Pesquisar produtos'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          children: [
            DefaultSearchProducts(
              searchValueController: searchValueController,
              isLoading: productsState.isLoading,
              searchProducts: searchProducts,
            ),
            gapH8,
            Expanded(
              child: AsyncValueWidget(
                value: productsState,
                tryAgain: null,
                data: (products) {
                  return ResponsiveListFlow(
                    itemCount: products.length,
                    itemBuilder: (_, index) {
                      final product = products[index];
                      return ProductItemWidget(
                        enterpriseCode: widget.enterpriseCode,
                        product: product,
                        routine: BsRoutine.priceConference,
                        notClickableBottom: PrimaryTextButton(
                          text: product.PendantPrintLabel
                              ? 'Desmarcar para impressão'.hardcoded
                              : 'Marcar para impressão'.hardcoded,
                          icon: Icon(
                            product.PendantPrintLabel
                                ? (isIOS
                                      ? CupertinoIcons.printer_fill
                                      : Icons.print_disabled)
                                : isIOS
                                ? CupertinoIcons.printer
                                : Icons.print,
                            color: product.PendantPrintLabel
                                ? Colors.red
                                : null,
                          ),
                          color: product.PendantPrintLabel ? Colors.red : null,
                          isLoading:
                              sendToPrintAsync.isLoading &&
                              index == lastChangedIndex,
                          onPressed: () async {
                            setState(() {
                              lastChangedIndex = index;
                            });
                            await ref
                                .read(sendToPrintControllerProvider.notifier)
                                .send(
                                  productPackingCode:
                                      product.ProductPackingCode,
                                  newValue: !product.PendantPrintLabel,
                                  enterpriseCode: widget.enterpriseCode,
                                  routine: BsRoutine.priceConference,
                                );
                          },
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
    );
  }
}
