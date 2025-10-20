import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

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
  final searchProductsController = TextEditingController();
  final quantityController = TextEditingController();
  final searchProductsFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();
  int? selectedIndex;
  bool insertIndividually = false;

  @override
  void dispose() {
    searchProductsController.dispose();
    quantityController.dispose();
    searchProductsFocusNode.dispose();
    quantityFocusNode.dispose();
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
        .loadProducts(searchProductsController.text);

    final products = ref.read(
      inventoryProductsStateControllerProvider(
        widget.enterpriseCode,
        widget.codigoInternoInventario,
        widget.codigoInternoInvCont,
      ),
    );

    if (insertIndividually && products.value?.length == 1) {
      ref
          .read(
            entryQuantityStateControllerProvider(
              widget.codigoInternoInvCont,
            ).notifier,
          )
          .entry(
            codigoInternoProEmb: products.value!.first.codigoInternoProEmb,
            quantity: 1,
            isSubtract: false,
            enterpriseCode: widget.enterpriseCode,
            codigoInternoInventario: widget.codigoInternoInventario,
          );
    }
  }

  void changeSelectedIndex(int index) {
    if (selectedIndex == index) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
      Future.delayed(Duration(milliseconds: 100), () {
        quantityFocusNode.requestFocus();
      });
    }
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
          setState(() {
            selectedIndex = null;
          });
          if (next.value?.length == 1) {
            setState(() {
              selectedIndex = 0;
            });
          }
          searchProductsController.clear();
          if (insertIndividually) {
            Future.delayed(Duration(milliseconds: 100), () {
              searchProductsFocusNode.requestFocus();
            });
          }
        });
        next.showSnackbarOnError(
          context,
          previous: previous,
          message: next.error,
        );
      },
    );

    final entryQuantityAsync = ref.watch(
      entryQuantityStateControllerProvider(widget.codigoInternoInvCont),
    );

    ref.listen(
      entryQuantityStateControllerProvider(widget.codigoInternoInvCont),
      (p, n) {
        n.showAlertDialogOnError(context);
        n.doOnSuccess(p, () {
          quantityController.clear();
        });
      },
    );

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('Produtos'.hardcoded)),
          body: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: DefaultSearchProducts(
                    focusNode: searchProductsFocusNode,
                    isLoading: productsState.isLoading,
                    searchProducts: _searchProducts,
                    searchValueController: searchProductsController,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: Sizes.p8),
                    child: DefaultSwitch(
                      title: 'Inserir individualmente'.hardcoded,
                      value: insertIndividually,
                      onChanged: (value) {
                        setState(() {
                          insertIndividually = value;
                        });
                      },
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: productsState.value?.length ?? 0,
                  itemBuilder: (_, index) {
                    final product = productsState.value![index];

                    return Card(
                      margin: const EdgeInsets.only(top: Sizes.p8),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          ProductInformations(
                            onChangeSelectedIndex: () =>
                                changeSelectedIndex(index),
                            product: product,
                            isSelected: selectedIndex == index,
                            entryQuantityAsync: entryQuantityAsync,
                          ),
                          if (selectedIndex == index) ...[
                            QuantityButtonsAndField(
                              insertIndividually: insertIndividually,
                              quantityFocusNode: quantityFocusNode,
                              quantityController: quantityController,
                              codigoInternoInvCont: widget.codigoInternoInvCont,
                              codigoInternoProEmb: product.codigoInternoProEmb,
                              enterpriseCode: widget.enterpriseCode,
                              codigoInternoInventario:
                                  widget.codigoInternoInventario,
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        if (entryQuantityAsync.isLoading) LoadingPage(),
      ],
    );
  }
}
