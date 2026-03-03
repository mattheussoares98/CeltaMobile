import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/infraestructure/infrastructure.dart';
import '../../../../../core/presentation/controllers/products/products.dart';
import '../../../../settings/presentation/controllers/controllers.dart';
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
  bool get _isContinuousScan =>
      ref
          .read(appSettingsStateControllerProvider)
          .value
          ?.inventoryUseContinuousScan ??
      false;
  bool get _insertIndividually => ref.read(
    uiStateControllerProvider(
      widget.codigoInternoInventario,
    ).select((s) => s.insertIndividually),
  );

  @override
  void dispose() {
    searchProductsController.dispose();
    quantityController.dispose();
    searchProductsFocusNode.dispose();
    quantityFocusNode.dispose();
    super.dispose();
  }

  Future<void> _searchProducts(
    SearchProductKey searchProductKey,
    bool searchByCamera,
  ) async {
    changeSelectedIndex(null);
    if (searchByCamera) {
      final code = await BarcodeScannerService.scanBarcode(context);
      if (code == null) return;
      searchProductsController.text = code;
    }
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
      searchProductsStateControllerProvider(
        searchProductKey,
      ).select((s) => s.hasError ? null : s.value),
    );

    if (_insertIndividually && products?.length == 1) {
      ref
          .read(
            entryQuantityStateControllerProvider(
              widget.codigoInternoInvCont,
            ).notifier,
          )
          .entry(
            codigoInternoProEmb: products!.first.codigoInternoProEmb!,
            quantity: 1,
            isSubtract: false,
            enterpriseCode: widget.enterpriseCode,
            codigoInternoInventario: widget.codigoInternoInventario,
          );
    }
  }

  void changeSelectedIndex(int? index) {
    final provider = uiStateControllerProvider(widget.codigoInternoInventario);
    ref.read(provider.notifier).updateProductIndex(index);

    if (ref.read(provider.select((s) => s.selectedProductIndex)) != null) {
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
        if (next.value?.length == 1) {
          changeSelectedIndex(0);
          quantityController.clear();
        }
      });
    });

    ref.listen(
      entryQuantityStateControllerProvider(widget.codigoInternoInvCont),
      (p, n) async {
        final products = await ref.watch(
          searchProductsStateControllerProvider(
            searchProductKey,
          ).selectAsync((s) => s),
        );

        n.showAlertDialogOnError(context);
        if (n.value != null) {
          n.showSnackbarOnSuccess(
            context,
            previous: p,
            message: 'Quantidade alterada com sucesso'.hardcoded,
          );
        }
        n.doOnSuccess(p, () async {
          if (products.isEmpty) {
            return;
          }
          quantityController.clear();

          if (_isContinuousScan && n.value != null) {
            await Future.delayed(const Duration(seconds: 1), () {
              _searchProducts(searchProductKey, true);
            });
          }
        });
      },
    );

    ref.observeLoading([
      entryQuantityStateControllerProvider(widget.codigoInternoInvCont),
    ]);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: DefaultAppBarTitle(
              enterpriseCode: widget.enterpriseCode,
              title: 'Produtos'.hardcoded,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
            child: Column(
              children: [
                Consumer(
                  builder: (_, ref, _) {
                    return DefaultSearchProducts(
                      focusNode: searchProductsFocusNode,
                      isLoading: ref.watch(
                        searchProductsStateControllerProvider(
                          searchProductKey,
                        ).select((state) => state.isLoading),
                      ),
                      searchProducts: () =>
                          _searchProducts(searchProductKey, false),
                      searchValueController: searchProductsController,
                      searchProductKey: searchProductKey,
                      module: Modules.inventory,
                    );
                  },
                ),
                InsertIndividuallySwitch(
                  codigoInternoInventario: widget.codigoInternoInventario,
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      ProductsItems(
                        codigoInternoInventario: widget.codigoInternoInventario,
                        codigoInternoInvCont: widget.codigoInternoInvCont,
                        enterpriseCode: widget.enterpriseCode,
                        searchProductKey: searchProductKey,
                        quantityFocusNode: quantityFocusNode,
                        quantityController: quantityController,
                      ),
                      gapSliverH48,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
