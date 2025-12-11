import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
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
  final formKeyQuantity = GlobalKey<FormState>();
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

  Future<void> _searchProducts(SearchProductKey searchProductKey) async {
    await ref
        .read(searchProductsStateControllerProvider(searchProductKey).notifier)
        .loadProducts(
          GetProductsInventoryParams(
            searchValue: searchProductsController.text,
            inventoryProcessCode: widget.codigoInternoInventario,
            inventoryCountingCode: widget.codigoInternoInvCont,
          ),
        );

    final products = ref.read(
      searchProductsStateControllerProvider(searchProductKey),
    );

    if (insertIndividually && products.value?.length == 1) {
      ref
          .read(
            entryQuantityStateControllerProvider(
              widget.codigoInternoInvCont,
            ).notifier,
          )
          .entry(
            codigoInternoProEmb: products.value!.first.codigoInternoProEmb!,
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
      quantityController.clear();
      Future.delayed(const Duration(milliseconds: 100), () {
        quantityFocusNode.requestFocus();
      });
    }
  }

  void entry(bool isSubtract, int codigoInternoProEmb) {
    if (formKeyQuantity.currentState?.validate() != true) {
      if (!quantityFocusNode.hasFocus) {
        quantityFocusNode.requestFocus();
      }
      return;
    }
    ref
        .read(
          entryQuantityStateControllerProvider(
            widget.codigoInternoInvCont,
          ).notifier,
        )
        .entry(
          codigoInternoInventario: widget.codigoInternoInventario,
          enterpriseCode: widget.enterpriseCode,
          codigoInternoProEmb: codigoInternoProEmb,
          quantity: insertIndividually
              ? 1
              : quantityController.text.toDouble()!,
          isSubtract: isSubtract,
        );
  }

  @override
  Widget build(BuildContext context) {
    final searchProductKey = SearchProductKey(
      widget.enterpriseCode,
      BsRoutine.generic,
      Modules.inventory,
      anotherKey:
          '${widget.codigoInternoInvCont}-${widget.codigoInternoInventario}',
    );
    ref.listen(searchProductsStateControllerProvider(searchProductKey), (
      previous,
      next,
    ) {
      next.doOnSuccess(previous, () {
        setState(() {
          selectedIndex = null;
        });
        if (next.value?.length == 1) {
          setState(() {
            selectedIndex = 0;
          });
          //TODO create a new controller to select the index, to avoid update the entire page
          quantityController.clear();
        }
        if (insertIndividually) {
          Future.delayed(const Duration(milliseconds: 100), () {
            searchProductsFocusNode.requestFocus();
          });
        }
      });
      next.showSnackbarOnError(context, previous);
    });

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
                SearchProducts(
                  searchProducts: () => _searchProducts(searchProductKey),
                  searchProductsController: searchProductsController,
                  searchProductsFocusNode: searchProductsFocusNode,
                  enterpriseCode: widget.enterpriseCode,
                  codigoInternoInventario: widget.codigoInternoInventario,
                  codigoInternoInvCont: widget.codigoInternoInvCont,
                  searchProductKey: searchProductKey,
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
                Consumer(
                  builder: (_, ref, _) {
                    final productsState = ref.watch(
                      searchProductsStateControllerProvider(searchProductKey),
                    );
                    return SliverList.builder(
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
                                codigoInternoInvCont:
                                    widget.codigoInternoInvCont,
                              ),
                              if (selectedIndex == index) ...[
                                QuantityButtonsAndField(
                                  insertIndividually: insertIndividually,
                                  quantityFocusNode: quantityFocusNode,
                                  quantityController: quantityController,
                                  codigoInternoInvCont:
                                      widget.codigoInternoInvCont,
                                  codigoInternoProEmb:
                                      product.codigoInternoProEmb!,
                                  enterpriseCode: widget.enterpriseCode,
                                  codigoInternoInventario:
                                      widget.codigoInternoInventario,
                                  entryQuantity: (isSubtract) => entry(
                                    isSubtract,
                                    product.codigoInternoProEmb!,
                                  ),
                                  formKey: formKeyQuantity,
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        LoadingPage(
          providers: [
            entryQuantityStateControllerProvider(widget.codigoInternoInvCont),
          ],
        ),
      ],
    );
  }
}
