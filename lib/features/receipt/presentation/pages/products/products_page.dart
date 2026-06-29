import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/infraestructure/infrastructure.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/receipt/presentation/pages/products/components/components.dart';
import 'package:celta_inventario/features/settings/presentation/controllers/controllers.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  final searchProductController = TextEditingController();
  final searchProductFocusNode = FocusNode();

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
    searchProductController.dispose();
    searchProductFocusNode.dispose();
    super.dispose();
  }

  void searchProductByAutoScan(SearchProductKey searchProductKey) async {
    bool isContinuousScan = await ref.read(
      appSettingsStateControllerProvider.select(
        (s) => s.value?.receiptUseContinuousScan == true,
      ),
    );

    if (isContinuousScan == true && mounted) {
      final value = await BarcodeScannerService.scanBarcode(context);

      if (value == null) {
        return;
      } else {
        searchProductController.text = value;
        await ref
            .read(
              searchProductsStateControllerProvider(searchProductKey).notifier,
            )
            .loadProducts(
              exactProductCode: null,
              GetProductsReceiptParams(
                searchValue: searchProductController.text,
                grDocCode: widget.receiptCode,
              ),
            );

        final selectFirstItem = ref.read(
          searchProductsStateControllerProvider(
            searchProductKey,
          ).select((s) => !s.hasError && s.value?.length == 1),
        );

        if (selectFirstItem) {
          ref
              .read(
                selectedProductIndeStateControllerProvider(
                  widget.receiptCode,
                ).notifier,
              )
              .updateIndex(0, annulWhenIsSame: false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchProductKey = SearchProductKey(
      widget.enterpriseCode,
      BsRoutine.goodsReceiving,
      Modules.receipt,
      anotherKey: widget.receiptCode.toString(),
    );

    ref.listen(updateProductControllerProvider(searchProductKey), (p, n) {
      n.showAlertDialogOnError(context);
      n.doOnSuccess(p, () {
        quantityController.clear();
        searchProductFocusNode.requestFocus();
        searchProductByAutoScan(searchProductKey);
      });
    });

    ref.observeLoading([updateProductControllerProvider(searchProductKey)]);

    const horizontalPadding = EdgeInsets.symmetric(horizontal: Sizes.p4);

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      resizeToAvoidBottomInset: true,
      appBar: BaseAppBar(titleWidget: AppBarTitle(receipt: receiptState)),
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
        child: const PlatformIcon(
          cupertinoIcon: CupertinoIcons.add,
          materialIcon: Icons.add,
        ),
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
              searchProductController: searchProductController,
              searchProductFocusNode: searchProductFocusNode,
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
                  gapSliverH80,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
