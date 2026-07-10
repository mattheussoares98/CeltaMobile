import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/features/receipt/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/receipt/presentation/pages/pages.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductsNotFoundPage extends ConsumerStatefulWidget {
  final int receiptCode;
  final int enterpriseCode;
  const ProductsNotFoundPage({
    super.key,
    required this.receiptCode,
    required this.enterpriseCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductsNotFoundPageState();
}

class _ProductsNotFoundPageState extends ConsumerState<ProductsNotFoundPage> {
  final eanController = TextEditingController();
  final quantityController = TextEditingController();
  final observationsController = TextEditingController();
  final quantityFocusNode = FocusNode();
  final observationsFocusNode = FocusNode();
  final eanFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    eanController.dispose();
    quantityController.dispose();
    observationsController.dispose();
    quantityFocusNode.dispose();
    observationsFocusNode.dispose();
    eanFocusNode.dispose();
  }

  Future<void> onSubmit(int? internalCode) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final succeds = await ref
        .read(
          insertProductNotFoundControllerProvider(widget.receiptCode).notifier,
        )
        .insert(
          quantity: quantityController.text.toDouble()!,
          ean: eanController.text,
          observations: observationsController.text,
          internalCode: internalCode,
        );

    if (succeds && mounted) {
      context.pop();
    }
  }

  void openInsertUpdateProductPage(ProductNotFoundEntity? product) {
    if (product != null) {
      eanController.text = product.ean;
      quantityController.text = product.quantity
          .toString()
          .toBrazilianNumber()
          .replaceAll(RegExp(r'\.'), '');
      observationsController.text = product.observations == 'null'
          ? ""
          : product.observations ?? "";
    } else {
      eanController.clear();
      quantityController.clear();
      observationsController.clear();
    }
    showModalPage(
      InsertUpdateProductPage(
        isEditing: product != null,
        receiptCode: widget.receiptCode,
        formKey: formKey,
        quantityFocusNode: quantityFocusNode,
        observationsFocusNode: observationsFocusNode,
        eanFocusNode: eanFocusNode,
        eanController: eanController,
        quantityController: quantityController,
        observationsController: observationsController,
        onSubmit: () => onSubmit(product?.internalCode),
      ),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onRefresh() async {
      ref.invalidate(
        productsNotFoundStateControllerProvider(widget.receiptCode),
      );
    }

    return BaseScaffold(
      isScrollable: false,
      refreshProvider: productsNotFoundStateControllerProvider(
        widget.receiptCode,
      ),
      appBar: BaseAppBar(
        title: 'Produtos não encontrados'.hardcoded,
        selectedEnterpriseCode: widget.enterpriseCode,
      ),
      floatingActionButton: FloatingActionButton(
        child: const PlatformIcon(
          cupertinoIcon: CupertinoIcons.add,
          materialIcon: Icons.add,
        ),
        onPressed: () => openInsertUpdateProductPage(null),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            value: ref.watch(
              productsNotFoundStateControllerProvider(widget.receiptCode),
            ),
            tryAgain: onRefresh,
            data: (products) {
              return ResponsiveListFlow(
                itemCount: products.length,
                itemBuilder: (_, index) {
                  final product = products[index];

                  return _ProductItem(
                    key: ValueKey(product.ean),
                    product: product,
                    openInsertUpdateProductPage: () =>
                        openInsertUpdateProductPage(product),
                    bottomPadding: (products.length == index + 1)
                        ? Sizes.p64
                        : 0, //avoid overlay the floating button,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final ProductNotFoundEntity product;
  final VoidCallback openInsertUpdateProductPage;
  final double bottomPadding;
  const _ProductItem({
    super.key,
    required this.product,
    required this.openInsertUpdateProductPage,
    required this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: bottomPadding, //avoid overlay the floating button
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: openInsertUpdateProductPage,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleAndSubTitle(
                        title: 'EAN'.hardcoded,
                        subTitle: product.ean,
                      ),
                      TitleAndSubTitle(
                        title: 'Quantidade'.hardcoded,
                        subTitle: product.quantity
                            .toString()
                            .toBrazilianNumber(),
                      ),
                      if (product.observations != null &&
                          product.observations!.isNotEmpty &&
                          product.observations.toString() != 'null')
                        TitleAndSubTitle(
                          title: 'Observações'.hardcoded,
                          subTitle: product.observations,
                        ),
                    ],
                  ),
                ),
                const Positioned(
                  top: Sizes.p8,
                  right: Sizes.p8,
                  child: PlatformIcon(
                    cupertinoIcon: CupertinoIcons.pencil,
                    materialIcon: Icons.edit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
