import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../core/presentation/controllers/scanner/scanner.dart';
import '../../../../../utils/utils.dart';
import '../../../../settings/presentation/controllers/controllers.dart';
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

  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();

  @override
  void dispose() {
    quantityController.dispose();
    quantityFocusNode.dispose();
    searchValueController.dispose();
    super.dispose();
  }

  void searchProductByAutoScan(SearchProductKey searchProductKey) async {
    bool searchByCamera = await ref.read(
      appSettingsStateControllerProvider.select(
        (s) => s.value?.receiptUseContinuousScan == true,
      ),
    );

    if (searchByCamera == true) {
      final value = await ref.read(
        barcodeScannerStateControllerProvider.future,
      );
      if (value == null) {
        return;
      } else {
        searchValueController.text = value;
        ref
            .read(
              searchProductsStateControllerProvider(searchProductKey).notifier,
            )
            .loadProducts(
              GetProductsReceiptParams(
                searchValue: searchValueController.text,
                grDocCode: widget.receiptCode,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchProductKey = SearchProductKey(
      widget.enterpriseCode,
      BsRoutine.goodsReceiving,
      Modules.receipt,
    );

    ref.listen(updateProductControllerProvider(searchProductKey), (p, n) {
      n.showAlertDialogOnError(context);
      n.doOnSuccess(p, () {
        quantityController.clear();
        searchProductByAutoScan(searchProductKey);
      });
    });

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: AppBarTitle(receipt: widget.receipt)),
          body: Column(
            children: [
              TopButtons(
                searchProductKey: searchProductKey,
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
                      SearchProducts(
                        searchProductKey: searchProductKey,
                        searchValueController: searchValueController,
                        receiptCode: widget.receiptCode,
                      ),
                      gapH8,
                      Expanded(
                        child: ProductsItems(
                          searchProductKey: searchProductKey,
                          receiptCode: widget.receiptCode,
                          quantityController: quantityController,
                          quantityFocusNode: quantityFocusNode,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        LoadingPage(
          providers: [updateProductControllerProvider(searchProductKey)],
        ),
      ],
    );
  }
}
