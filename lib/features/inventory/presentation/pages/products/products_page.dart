import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../controllers/controllers.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int codigoInternoInvCont;
  final int codigoInternoInventario;
  const ProductsPage({
    super.key,
    required this.enterpriseCode,
    required this.codigoInternoInvCont,
    required this.codigoInternoInventario,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _searchProducts() async {
    await ref
        .read(
          inventoryProductsStateControllerProvider(
            widget.enterpriseCode,
            widget.codigoInternoInventario,
            widget.codigoInternoInvCont,
          ).notifier,
        )
        .loadProducts(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(
      inventoryProductsStateControllerProvider(
        widget.enterpriseCode,
        widget.codigoInternoInventario,
        widget.codigoInternoInvCont,
      ),
    );
    ref.listen(
      inventoryProductsStateControllerProvider(
        widget.enterpriseCode,
        widget.codigoInternoInventario,
        widget.codigoInternoInvCont,
      ),
      (previous, next) {
        next.doOnSuccess(previous, () {
          controller.clear();
          Future.delayed(Duration(milliseconds: 100), () {
            //TODO change the focus only when is individual setting
            focusNode.requestFocus();
          });
        });
        next.showSnackbarOnError(
          context,
          previous: previous,
          message: next.error,
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text('Produtos'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: DefaultSearchProducts(
                focusNode: focusNode,
                isLoading: productsState.isLoading,
                searchProducts: _searchProducts,
                searchValueController: controller,
              ),
            ),
            SliverList.builder(
              itemCount: productsState.value?.length ?? 0,
              itemBuilder: (_, index) {
                final product = productsState.value![index];

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(children: [Text(product.productName)]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
