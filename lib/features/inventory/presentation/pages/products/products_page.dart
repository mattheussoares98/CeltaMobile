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

  void changeSelectedIndex(int? index) {
    ref
        .read(selectedProductIndexStateControllerProvider.notifier)
        .updateIndex(index);

    if (ref.read(selectedProductIndexStateControllerProvider) != null) {
      quantityController.clear();
      Future.delayed(const Duration(milliseconds: 100), () {
        quantityFocusNode.requestFocus();
      });
    }
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
        changeSelectedIndex(null);
        if (next.value?.length == 1) {
          changeSelectedIndex(0);
          quantityController.clear();
        }
        if (insertIndividually) {
          Future.delayed(const Duration(milliseconds: 100), () {
            searchProductsFocusNode.requestFocus();
          });
        }
      });
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
                AsyncValueSliverWidget(
                  value: ref.watch(
                    searchProductsStateControllerProvider(searchProductKey),
                  ),
                  tryAgain: null,
                  data: (products) {
                    return SliverList.builder(
                      itemCount: products.length,
                      itemBuilder: (_, index) {
                        final product = products[index];

                        return ProductItem(
                          widget: widget,
                          changeSelectedIndex: changeSelectedIndex,
                          index: index,
                          product: product,
                          insertIndividually: insertIndividually,
                          quantityFocusNode: quantityFocusNode,
                          quantityController: quantityController,
                          formKeyQuantity: formKeyQuantity,
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
