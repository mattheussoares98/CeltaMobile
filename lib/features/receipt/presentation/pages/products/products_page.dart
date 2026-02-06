import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../../core/presentation/controllers/scanner/scanner.dart';
import '../../../../../routing/routing.dart';
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

  ReceiptEntity? receiptState;

  @override
  void initState() {
    receiptState = widget.receipt;
    super.initState();
  }

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

    ref.observeLoading([updateProductControllerProvider(searchProductKey)]);

    const horizontalPadding = EdgeInsets.symmetric(horizontal: Sizes.p4);

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          receipt: receiptState,
          enterpriseCode: widget.enterpriseCode,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(
            Routes.receiptProductsNotFound.name,
            pathParameters: {
              'enterpriseCode': widget.enterpriseCode.toString(),
              'receiptCode': widget.receiptCode.toString(),
            },
          );
        },
        child: Icon(!isIOS ? CupertinoIcons.add : Icons.add),
      ),
      body: Column(
        children: [
          TopButtons(
            searchProductKey: searchProductKey,
            enterpriseCode: widget.enterpriseCode,
            receiptCode: widget.receiptCode,
          ),
          Padding(
            padding: horizontalPadding,
            child: SearchProducts(
              searchProductKey: searchProductKey,
              searchValueController: searchValueController,
              receiptCode: widget.receiptCode,
            ),
          ),
          gapH8,
          Expanded(
            child: Padding(
              padding: horizontalPadding,
              child: CustomScrollView(
                slivers: [
                  ProductsItems(
                    searchProductKey: searchProductKey,
                    receiptCode: widget.receiptCode,
                    quantityController: quantityController,
                    quantityFocusNode: quantityFocusNode,
                  ),
                  gapSliverH48,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
